cacertHook() {
    export SSL_CERT_FILE=@out@/etc/ssl/certs/ca-bundle.crt
}

envHooks+=(cacertHook)
crossEnvHooks+=(cacertHook)
