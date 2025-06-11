httpxSslCertFileUnset() {
    unset SSL_CERT_FILE
}

postHooks+=(httpxSslCertFileUnset)
