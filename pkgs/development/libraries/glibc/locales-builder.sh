# Glibc cannot have itself in its RPATH.
export NIX_NO_SELF_RPATH=1

postConfigure() {
    # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
    # This has to be done *after* `configure' because it builds some
    # test binaries.
    export NIX_CFLAGS_LINK=
    export NIX_LDFLAGS_BEFORE=

    export NIX_DONT_SET_RPATH=1
    unset CFLAGS
}

genericBuild
