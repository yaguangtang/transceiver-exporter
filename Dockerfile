FROM golang:1.19-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o transceiver-exporter

FROM alpine:3.19

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/transceiver-exporter /usr/local/bin/transceiver-exporter

EXPOSE 9458

ENTRYPOINT ["transceiver-exporter"]
