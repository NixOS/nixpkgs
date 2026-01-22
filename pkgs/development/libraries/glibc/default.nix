{
  lib,
  stdenv,
  callPackage,
  withLinuxHeaders ? true,
  linuxHeaders ? null,
  profilingLibraries ? false,
  withGd ? false,
  enableCET ? if stdenv.hostPlatform.isx86_64 then "permissive" else false,
  enableCETRuntimeDefault ? false,
  pkgsBuildBuild,
  libgcc,
}:

let
  gdCflags = [
    "-Wno-error=stringop-truncation"
    "-Wno-error=missing-attributes"
    "-Wno-error=array-bounds"
  ];
in

(callPackage ./common.nix { inherit stdenv linuxHeaders; } {
  inherit
    withLinuxHeaders
    withGd
    profilingLibraries
    enableCET
    enableCETRuntimeDefault
    ;
  pname =
    "glibc"
    + lib.optionalString withGd "-gd"
    + lib.optionalString (stdenv.cc.isGNU && libgcc == null) "-nolibgcc";
}).overrideAttrs
  (previousAttrs: {

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
    '';

    # The stackprotector and fortify hardening flags are autodetected by
    # glibc and enabled by default if supported. Setting it for every gcc
    # invocation does not work.
    hardeningDisable = [
      "fortify"
      "stackprotector"
      "strictflexarrays3"
    ];

    env = (previousAttrs.env or { }) // {
      NIX_CFLAGS_COMPILE =
        (previousAttrs.env.NIX_CFLAGS_COMPILE or "")
        + lib.concatStringsSep " " (
          builtins.concatLists [
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
            (lib.optionals (stdenv.hostPlatform.isPower64) [
              # Do not complain about the Processor Specific ABI (i.e. the
              # choice to use IEEE-standard `long double`).  We pass this
              # flag in order to mute a `-Werror=psabi` passed by glibc;
              # hopefully future glibc releases will not pass that flag.
              "-Wno-error=psabi"
            ])
          ]
        );
    };

    # glibc needs to `dlopen()` `libgcc_s.so` but does not link
    # against it.  Furthermore, glibc doesn't use the ordinary
    # `dlopen()` call to do this; instead it uses one which ignores
    # most paths:
    #
    #   https://sourceware.org/legacy-ml/libc-help/2013-11/msg00026.html
    #
    # In order to get it to not ignore `libgcc_s.so`, we have to add its path to
    # `user-defined-trusted-dirs`:
    #
    #   https://sourceware.org/git/?p=glibc.git;a=blob;f=elf/Makefile;h=b509b3eada1fb77bf81e2a0ca5740b94ad185764#l1355
    #
    # Conveniently, this will also inform Nix of the fact that glibc depends on
    # gcc.libgcc, since the path will be embedded in the resulting binary.
    #
    makeFlags =
      (previousAttrs.makeFlags or [ ])
      ++ lib.optionals (libgcc != null) [
        "user-defined-trusted-dirs=${libgcc}/lib"
      ];

    postInstall =
      previousAttrs.postInstall
      + (
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          ''
            echo SUPPORTED-LOCALES=C.UTF-8/UTF-8 > ../glibc-2*/localedata/SUPPORTED
            # Don't install C.utf-8 into the archive, but into $out/lib/locale: on non-NixOS
            # systems with an empty /usr/lib/locale/locale-archive, glibc would fall back to
            # $libdir/locale/C.utf-8 instead of the locale archive of pkgs.glibc. See also #347965.
            make -j''${NIX_BUILD_CORES:-1} localedata/install-locale-files
          ''
        else
          lib.optionalString stdenv.buildPlatform.isLinux
            # This is based on http://www.linuxfromscratch.org/lfs/view/development/chapter06/glibc.html
            # Instead of using their patch to build a build-native localedef,
            # we simply use the one from pkgsBuildBuild.
            #
            # Note that we can't use pkgsBuildHost (aka buildPackages) here, because
            # that will cause an eval-time infinite recursion: "buildPackages.glibc
            # depended on buildPackages.libgcc, which, since it's GCC, depends on the
            # target's bintools, which depend on the target's glibc, which, again,
            # depends on buildPackages.glibc, causing an infinute recursion when
            # evaluating buildPackages.glibc when glibc hasn't come from stdenv
            # (e.g. on musl)." https://github.com/NixOS/nixpkgs/pull/259964
            ''
              pushd ../glibc-2*/localedata
              export I18NPATH=$PWD GCONV_PATH=$PWD/../iconvdata
              mkdir -p $NIX_BUILD_TOP/${pkgsBuildBuild.glibc}/lib/locale
              ${lib.getBin pkgsBuildBuild.glibc}/bin/localedef \
                --alias-file=../intl/locale.alias \
                -i locales/C \
                -f charmaps/UTF-8 \
                --prefix $NIX_BUILD_TOP \
                ${
                  if stdenv.hostPlatform.parsed.cpu.significantByte.name == "littleEndian" then
                    "--little-endian"
                  else
                    "--big-endian"
                } \
                C.UTF-8
              cp -r $NIX_BUILD_TOP/${pkgsBuildBuild.glibc}/lib/locale $out/lib
              popd
            ''
      )
      + ''

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
        test -f $out/lib/libutil.so.1 && ln -sf $out/lib/libutil.so.1 $out/lib/libutil.so
        touch $out/lib/libpthread.a

        # Put libraries for static linking in a separate output.  Note
        # that libc_nonshared.a and libpthread_nonshared.a are required
        # for dynamically-linked applications.
        mkdir -p $static/lib
        mv $out/lib/*.a $static/lib
        mv $static/lib/lib*_nonshared.a $out/lib
        # If libutil.so.1 is missing, libutil.a is required.
        test -f $out/lib/libutil.so.1 || mv $static/lib/libutil.a $out/lib
        # Some of *.a files are linker scripts where moving broke the paths.
        sed "/^GROUP/s|$out/lib/lib|$static/lib/lib|g" \
          -i "$static"/lib/*.a

        # Work around a Nix bug: hard links across outputs cause a build failure.
        cp $bin/bin/getconf $bin/bin/getconf_
        mv $bin/bin/getconf_ $bin/bin/getconf
      '';

    separateDebugInfo = true;

    passthru =
      (previousAttrs.passthru or { })
      // lib.optionalAttrs (libgcc != null) {
        inherit libgcc;
      };

    meta = (previousAttrs.meta or { }) // {
      description = "GNU C Library";
    };
  })
