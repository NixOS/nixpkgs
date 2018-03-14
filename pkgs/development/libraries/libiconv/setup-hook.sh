# libiconv must be listed in load flags on non-Glibc
# it doesn't hurt to have it in Glibc either though
iconvLdflags() {
    export NIX_LDFLAGS="$NIX_LDFLAGS -liconv"
}

addEnvHooks "$hostOffset" iconvLdflags
