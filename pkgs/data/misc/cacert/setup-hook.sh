if test -r "$NIX_SSL_CERT_FILE"; then
  # Don't somehow log this more than once, or log if it's irrelevant
  if [[ "$NIX_SSL_CERT_FILE" != "@out@/etc/ssl/certs/ca-bundle.crt" ]]; then
    echo "cacert/setup-hook: inheriting existing NIX_SSL_CERT_FILE $NIX_SSL_CERT_FILE" >&2
  fi
else
  if test -n "$NIX_SSL_CERT_FILE"; then
    echo "cacert/setup-hook: NIX_SSL_CERT_FILE in environment $NIX_SSL_CERT_FILE cannot be read; overriding" >&2
  fi
  export NIX_SSL_CERT_FILE="@out@/etc/ssl/certs/ca-bundle.crt"
fi

# compatibility
#  - openssl
export SSL_CERT_FILE=$NIX_SSL_CERT_FILE
#  - Haskell x509-system
export SYSTEM_CERTIFICATE_PATH=$NIX_SSL_CERT_FILE
