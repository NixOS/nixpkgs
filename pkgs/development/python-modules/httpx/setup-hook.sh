httpxSslCertFileUnset() {
  if [ ! -e "${SSL_CERT_FILE-}" ]; then
    unset SSL_CERT_FILE
  fi
}

postHooks+=(httpxSslCertFileUnset)
