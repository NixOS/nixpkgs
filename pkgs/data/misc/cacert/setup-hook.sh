export NIX_SSL_CERT_FILE=@out@/etc/ssl/certs/ca-bundle.crt

# compatibility
#  - openssl
export SSL_CERT_FILE=@out@/etc/ssl/certs/ca-bundle.crt
#  - Haskell x509-system
export SYSTEM_CERTIFICATE_PATH=@out@/etc/ssl/certs/ca-bundle.crt
