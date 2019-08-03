cacertHook() {
    export NIX_SSL_CERT_FILE=@out@/etc/ssl/certs/ca-bundle.crt
    # left for compatibility
    export SSL_CERT_FILE=@out@/etc/ssl/certs/ca-bundle.crt
}

addEnvHooks "$targetOffset" cacertHook
