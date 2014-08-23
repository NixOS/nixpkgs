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

    # Apparently --bindir is not respected.
    makeFlagsArray+=("bindir=$bin/bin" "sbindir=$bin/sbin" "rootsbindir=$bin/sbin")
}


postInstall() {
    if test -n "$installLocales"; then
        make -j${NIX_BUILD_CORES:-1} -l${NIX_BUILD_CORES:-1} localedata/install-locales
    fi

    test -f $out/etc/ld.so.cache && rm $out/etc/ld.so.cache

    # FIXME: Use `test -n $linuxHeaders' when `kernelHeaders' has been
    # renamed.
    if test -z "$hurdHeaders"; then
        # Include the Linux kernel headers in Glibc, except the `scsi'
        # subdirectory, which Glibc provides itself.
        (cd $dev/include && \
         ln -sv $(ls -d $kernelHeaders/include/* | grep -v 'scsi$') .)
    fi

    if test -f "$out/lib/libhurduser.so"; then
        # libc.so, libhurduser.so, and libmachuser.so depend on each
        # other, so add them to libc.so (a RUNPATH on libc.so.0.3
        # would be ignored by the cross-linker.)
        echo "adding \`libhurduser.so' and \`libmachuser.so' to the \`libc.so' linker script..."
        sed -i "$out/lib/libc.so" \
            -e"s|\(libc\.so\.[^ ]\+\>\)|\1 $out/lib/libhurduser.so $out/lib/libmachuser.so|g"
    fi

    # Fix for NIXOS-54 (ldd not working on x86_64).  Make a symlink
    # "lib64" to "lib".
    if test -n "$is64bit"; then
        ln -s lib $out/lib64
    fi

    # This file, that should not remain in the glibc derivation,
    # may have not been created during the preInstall
    rm -f $out/lib/libgcc_s.so.1

    # Get rid of more unnecessary stuff.
    rm -rf $out/var $out/sbin/sln

    # Put libraries for static linking in a separate output.  Note
    # that libc_nonshared.a and libpthread_nonshared.a are required
    # for dynamically-linked applications.
    mkdir -p $static/lib
    mv $out/lib/*.a $static/lib
    mv $static/lib/lib*_nonshared.a $out/lib

    # Work around a Nix bug: hard links across outputs cause a build failure.
    cp $bin/bin/getconf $bin/bin/getconf_
    mv $bin/bin/getconf_ $bin/bin/getconf
}

genericBuild
