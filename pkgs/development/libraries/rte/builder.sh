. $stdenv/setup

configureScript=configure
configure() {
    # !!! hack: configure returns non-zero even on success.
    ./configure $configureFlags || true
}

genericBuild