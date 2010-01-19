# Glibc cannot have itself in its RPATH.
export NIX_NO_SELF_RPATH=1

source $stdenv/setup

postConfigure() {
    # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
    # This has to be done *after* `configure' because it builds some
    # test binaries.
    export NIX_CFLAGS_LINK=
    export NIX_LDFLAGS_BEFORE=

    export NIX_DONT_SET_RPATH=1
    unset CFLAGS
}


postInstall() {
    if test -n "$installLocales"; then
        make localedata/install-locales
    fi
    
    test -f $out/etc/ld.so.cache && rm $out/etc/ld.so.cache

    # Include the Linux kernel headers in Glibc, except the `scsi'
    # subdirectory, which Glibc provides itself. 
    (cd $out/include && ln -s $(ls -d $kernelHeaders/include/* | grep -v 'scsi$') .)

    # Fix for NIXOS-54 (ldd not working on x86_64).  Make a symlink
    # "lib64" to "lib".
    if test -n "$is64bit"; then
        ln -s lib $out/lib64
    fi

    rm $out/lib/libgcc_s.so.1
}


genericBuild
