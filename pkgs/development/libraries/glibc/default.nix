{ stdenv, callPackage
, withLinuxHeaders ? true
, profilingLibraries ? false
, withGd ? false
, buildPackages
}:

let
  gdCflags = [
    "-Wno-error=stringop-truncation"
    "-Wno-error=missing-attributes"
    "-Wno-error=array-bounds"
  ];
in

callPackage ./common.nix { inherit stdenv; } {
    name = "glibc" + stdenv.lib.optionalString withGd "-gd";

    inherit withLinuxHeaders profilingLibraries withGd;

    # Note:
    # Things you write here override, and do not add to,
    # the values in `common.nix`.
    # (For example, if you define `patches = [...]` here, it will
    # override the patches in `common.nix`.)

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
    hardeningDisable = [ "stackprotector" "fortify" ]
    # XXX: Not actually musl-speciic but since only musl enables pie by default,
    #      limit rebuilds by only disabling pie w/musl
      ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "pie";

    NIX_CFLAGS_COMPILE = stdenv.lib.concatStringsSep " "
      (if !stdenv.hostPlatform.isMusl
        # TODO: This (returning a string or `null`, instead of a list) is to
        #       not trigger a mass rebuild due to the introduction of the
        #       musl-specific flags below.
        #       At next change to non-musl glibc builds, remove this `then`
        #       and the above condition, instead keeping only the `else` below.
        then (stdenv.lib.optionals withGd gdCflags)
        else
          (builtins.concatLists [
            (stdenv.lib.optionals withGd gdCflags)
            # Fix -Werror build failure when building glibc with musl with GCC >= 8, see:
            # https://github.com/NixOS/nixpkgs/pull/68244#issuecomment-544307798
            (stdenv.lib.optional stdenv.hostPlatform.isMusl "-Wno-error=attribute-alias")
          ]));

    # When building glibc from bootstrap-tools, we need libgcc_s at RPATH for
    # any program we run, because the gcc will have been placed at a new
    # store path than that determined when built (as a source for the
    # bootstrap-tools tarball)
    # Building from a proper gcc staying in the path where it was installed,
    # libgcc_s will not be at {gcc}/lib, and gcc's libgcc will be found without
    # any special hack.
    preInstall = ''
      if [ -f ${stdenv.cc.cc}/lib/libgcc_s.so.1 ]; then
          mkdir -p $out/lib
          cp ${stdenv.cc.cc}/lib/libgcc_s.so.1 $out/lib/libgcc_s.so.1
          # the .so It used to be a symlink, but now it is a script
          cp -a ${stdenv.cc.cc}/lib/libgcc_s.so $out/lib/libgcc_s.so
      fi
    '';

    postInstall = (if stdenv.hostPlatform == stdenv.buildPlatform then ''
      echo SUPPORTED-LOCALES=C.UTF-8/UTF-8 > ../glibc-2*/localedata/SUPPORTED
      make -j''${NIX_BUILD_CORES:-1} -l''${NIX_BUILD_CORES:-1} localedata/install-locales
    '' else stdenv.lib.optionalString stdenv.buildPlatform.isLinux ''
      # This is based on http://www.linuxfromscratch.org/lfs/view/development/chapter06/glibc.html
      # Instead of using their patch to build a build-native localedef,
      # we simply use the one from buildPackages
      pushd ../glibc-2*/localedata
      export I18NPATH=$PWD GCONV_PATH=$PWD/../iconvdata
      mkdir -p $NIX_BUILD_TOP/${buildPackages.glibc}/lib/locale
      ${stdenv.lib.getBin buildPackages.glibc}/bin/localedef \
        --alias-file=../intl/locale.alias \
        -i locales/C \
        -f charmaps/UTF-8 \
        --prefix $NIX_BUILD_TOP \
        ${if stdenv.hostPlatform.parsed.cpu.significantByte.name == "littleEndian" then
            "--little-endian"
          else
            "--big-endian"} \
        C.UTF-8
      cp -r $NIX_BUILD_TOP/${buildPackages.glibc}/lib/locale $out/lib
      popd
    '') + ''

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
