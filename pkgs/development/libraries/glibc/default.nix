{ stdenv, callPackage
, withLinuxHeaders ? true
, installLocales ? true
, profilingLibraries ? false
, withGd ? false
}:

callPackage ./common.nix { inherit stdenv; } {
    name = "glibc" + stdenv.lib.optionalString withGd "-gd";

    inherit withLinuxHeaders profilingLibraries installLocales withGd;

    NIX_NO_SELF_RPATH = true;

    postConfigure = ''
      # Hack: get rid of the `-static' flag set by the bootstrap stdenv.
      # This has to be done *after* `configure' because it builds some
      # test binaries.
      export NIX_CFLAGS_LINK=
      export NIX_LDFLAGS_BEFORE=

      export NIX_DONT_SET_RPATH=1
      unset CFLAGS

      # Apparently --bindir is not respected.
      makeFlagsArray+=("bindir=$bin/bin" "sbindir=$bin/sbin" "rootsbindir=$bin/sbin")
    '';

    # The stackprotector and fortify hardening flags are autodetected by glibc
    # and enabled by default if supported. Setting it for every gcc invocation
    # does not work.
    hardeningDisable = [ "stackprotector" "fortify" ];

    postInstall = ''
      if test -n "$installLocales"; then
          make -j''${NIX_BUILD_CORES:-1} -l''${NIX_BUILD_CORES:-1} localedata/install-locales
      fi

      test -f $out/etc/ld.so.cache && rm $out/etc/ld.so.cache

      if test -n "$linuxHeaders"; then
          # Include the Linux kernel headers in Glibc, except the `scsi'
          # subdirectory, which Glibc provides itself.
          (cd $dev/include && \
           ln -sv $(ls -d $linuxHeaders/include/* | grep -v scsi\$) .)
      fi

      # Fix for NIXOS-54 (ldd not working on x86_64).  Make a symlink
      # "lib64" to "lib".
      if test -n "$is64bit"; then
          ln -s lib $out/lib64
      fi

      # Get rid of more unnecessary stuff.
      rm -rf $out/var $bin/bin/sln
    ''
      # For some reason these aren't stripped otherwise and retain reference
      # to bootstrap-tools; on cross-arm this stripping would break objects.
    + stdenv.lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''

      for i in "$out"/lib/*.a; do
          [ "$i" = "$out/lib/libm.a" ] || $STRIP -S "$i"
      done
    '' + ''

      # Put libraries for static linking in a separate output.  Note
      # that libc_nonshared.a and libpthread_nonshared.a are required
      # for dynamically-linked applications.
      mkdir -p $static/lib
      mv $out/lib/*.a $static/lib
      mv $static/lib/lib*_nonshared.a $out/lib
      # Some of *.a files are linker scripts where moving broke the paths.
      sed "/^GROUP/s|$out/lib/lib|$static/lib/lib|g" \
        -i "$static"/lib/*.a

      # Work around a Nix bug: hard links across outputs cause a build failure.
      cp $bin/bin/getconf $bin/bin/getconf_
      mv $bin/bin/getconf_ $bin/bin/getconf
    '';

    separateDebugInfo = true;

    meta.description = "The GNU C Library";
  }
