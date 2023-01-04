{ lib, stdenv, callPackage
, withLinuxHeaders ? true
, profilingLibraries ? false
, withGd ? false
, withLibcrypt? false
, buildPackages
}:

let
  gdCflags = [
    "-Wno-error=stringop-truncation"
    "-Wno-error=missing-attributes"
    "-Wno-error=array-bounds"
  ];
in

(callPackage ./common.nix { inherit stdenv; } {
  inherit withLinuxHeaders withGd profilingLibraries withLibcrypt;
  pname = "glibc" + lib.optionalString withGd "-gd";
}).overrideAttrs(previousAttrs: {

    # Note:
    # Things you write here override, and do not add to,
    # the values in `common.nix`.
    # (For example, if you define `patches = [...]` here, it will
    # override the patches in `common.nix` -- so instead you should
    # write `patches = (previousAttrs.patches or []) ++ [ ... ]`.

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
    '' + lib.optionalString stdenv.buildPlatform.isDarwin ''
      # ld-wrapper will otherwise attempt to inject CoreFoundation into ld-linux's RUNPATH
      export NIX_COREFOUNDATION_RPATH=
    '';

    # The pie, stackprotector and fortify hardening flags are autodetected by
    # glibc and enabled by default if supported. Setting it for every gcc
    # invocation does not work.
    hardeningDisable = [ "fortify" "pie" "stackprotector" ];

    NIX_CFLAGS_COMPILE = lib.concatStringsSep " "
      (builtins.concatLists [
        (lib.optionals withGd gdCflags)
        # Fix -Werror build failure when building glibc with musl with GCC >= 8, see:
        # https://github.com/NixOS/nixpkgs/pull/68244#issuecomment-544307798
        (lib.optional stdenv.hostPlatform.isMusl "-Wno-error=attribute-alias")
        (lib.optionals ((stdenv.hostPlatform != stdenv.buildPlatform) || stdenv.hostPlatform.isMusl) [
          # Ignore "error: '__EI___errno_location' specifies less restrictive attributes than its target '__errno_location'"
          # New warning as of GCC 9
          # Same for musl: https://github.com/NixOS/nixpkgs/issues/78805
          "-Wno-error=missing-attributes"
        ])
      ]);

    # When building glibc from bootstrap-tools, we need libgcc_s at RPATH for
    # any program we run, because the gcc will have been placed at a new
    # store path than that determined when built (as a source for the
    # bootstrap-tools tarball)
    # Building from a proper gcc staying in the path where it was installed,
    # libgcc_s will now be at {gcc}/lib, and gcc's libgcc will be found without
    # any special hack.
    # TODO: remove this hack. Things that rely on this hack today:
    # - dejagnu: during linux bootstrap tcl SIGSEGVs
    # - clang-wrapper in cross-compilation
    # Last attempt: https://github.com/NixOS/nixpkgs/pull/36948
    preInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
      if [ -f ${lib.getLib stdenv.cc.cc}/lib/libgcc_s.so.1 ]; then
          mkdir -p $out/lib
          cp ${lib.getLib stdenv.cc.cc}/lib/libgcc_s.so.1 $out/lib/libgcc_s.so.1
          # the .so It used to be a symlink, but now it is a script
          cp -a ${lib.getLib stdenv.cc.cc}/lib/libgcc_s.so $out/lib/libgcc_s.so
          # wipe out reference to previous libc it was built against
          chmod +w $out/lib/libgcc_s.so.1
          # rely on default RUNPATHs of the binary and other libraries
          # Do no force-pull wrong glibc.
          patchelf --remove-rpath $out/lib/libgcc_s.so.1
      fi
    '';

    postInstall = (if stdenv.hostPlatform == stdenv.buildPlatform then ''
      echo SUPPORTED-LOCALES=C.UTF-8/UTF-8 > ../glibc-2*/localedata/SUPPORTED
      make -j''${NIX_BUILD_CORES:-1} localedata/install-locales
    '' else lib.optionalString stdenv.buildPlatform.isLinux ''
      # This is based on http://www.linuxfromscratch.org/lfs/view/development/chapter06/glibc.html
      # Instead of using their patch to build a build-native localedef,
      # we simply use the one from buildPackages
      pushd ../glibc-2*/localedata
      export I18NPATH=$PWD GCONV_PATH=$PWD/../iconvdata
      mkdir -p $NIX_BUILD_TOP/${buildPackages.glibc}/lib/locale
      ${lib.getBin buildPackages.glibc}/bin/localedef \
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

      # Backwards-compatibility to fix e.g.
      # "configure: error: Pthreads are required to build libgomp" during `gcc`-build
      # because it's not actually needed anymore to link against `pthreads` since
      # it's now part of `libc.so.6` itself, but the gcc build breaks if
      # this doesn't work.
      ln -sf $out/lib/libpthread.so.0 $out/lib/libpthread.so
      ln -sf $out/lib/librt.so.1 $out/lib/librt.so
      ln -sf $out/lib/libdl.so.2 $out/lib/libdl.so
      ln -sf $out/lib/libutil.so.1 $out/lib/libutil.so
      touch $out/lib/libpthread.a

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

  meta = (previousAttrs.meta or {}) // { description = "The GNU C Library"; };
})

