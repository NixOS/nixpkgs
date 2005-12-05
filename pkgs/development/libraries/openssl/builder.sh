source $stdenv/setup

configureScript=./config
configureFlags=shared

postInstall=postInstall
postInstall() {
    # Bug fix: openssl does a `chmod 644' on the pkgconfig directory.
    chmod 755 $out/lib/pkgconfig || exit 1
}

genericBuild
