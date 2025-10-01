{
  lib,
  stdenv,
  fetchurl,
  pkgsBuildBuild,
  gawk,
  gmp,
  libtool,
  pkg-config,
  readline,
  libunistring,
  boehmgc,
  libffi,
}:

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = [
    "maintainers"
    "srcHash"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      srcHash ? "",
      ...
    }@args:
    {
      pname = args.pname or "guile";

      src = args.src or fetchurl {
        url = "mirror://gnu/guile/guile-${finalAttrs.version}.tar.gz";
        hash = srcHash;
      };

      patches =
        args.patches or [ ]
        ++ lib.optionals (lib.versionAtLeast finalAttrs.version "2.0.0") [
          ./2.0/eai_system.patch
        ];

      outputs =
        args.outputs or [
          "out"
          "dev"
          "info"
        ];

      setOutputFlags = args.setOutputFlags or false; # $dev gets into the library otherwise

      strictDeps = true;
      depsBuildBuild = args.depsBuildBuild or [ ] ++ [
        pkgsBuildBuild.stdenv.cc
      ];

      nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
        pkg-config
      ];

      buildInputs =
        args.buildInputs or [ ]
        ++ [
          libtool
          readline
        ]
        ++ lib.optionals (lib.versionAtLeast finalAttrs.version "2.0.0") [
          libunistring
          libffi
        ];

      propagatedBuildInputs =
        args.propagatedBuildInputs or [ ]
        ++ [
          gmp

          # XXX: These ones aren't normally needed here, but `libguile*.la' has '-l'
          # flags for them without corresponding '-L' flags. Adding them here will add
          # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
          # see below.
          libtool
        ]
        ++ lib.optionals (lib.versionAtLeast finalAttrs.version "2.0.0") [
          boehmgc
          libunistring
        ];

      env =
        args.env or { }
        //
          lib.optionalAttrs
            (
              (lib.versionAtLeast finalAttrs.version "2.0.0") && stdenv.cc.isGNU && !stdenv.hostPlatform.isStatic
            )
            {
              # Explicitly link against libgcc_s, to work around the infamous
              # "libgcc_s.so.1 must be installed for pthread_cancel to work".

              # don't have "libgcc_s.so.1" on clang
              LDFLAGS = "-lgcc_s";
            };

      # GCC 4.6 raises a number of set-but-unused warnings.
      configureFlags =
        args.configureFlags or [ ]
        ++ [
          "--disable-error-on-warning"
          "AWK=${lib.getExe gawk}"
        ]
        # Guile needs patching to preset results for the configure tests about
        # pthreads, which work only in native builds.
        ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--with-threads=no"
        ++ lib.optionals stdenv.hostPlatform.isSunOS [
          # Make sure the right <gmp.h> is found, and not the incompatible
          # /usr/include/mp.h from OpenSolaris. See
          # <https://lists.gnu.org/archive/html/hydra-users/2012-08/msg00000.html>
          # for details.
          "--with-libgmp-prefix=${lib.getDev gmp}"

          # Same for these (?).
          "--with-libreadline-prefix=${lib.getDev readline}"
          "--with-libunistring-prefix=${libunistring}"

          # See below.
          "--without-threads"
        ];

      enableParallelBuilding = args.enableParallelBuilding or true;

      # One test fails.
      # ERROR: file: "libtest-asmobs", message: "file not found"
      # This is fixed here:
      # <https://git.savannah.gnu.org/cgit/guile.git/commit/?h=branch_release-1-8&id=a0aa1e5b69d6ef0311aeea8e4b9a94eae18a1aaf>.
      doCheck = args.doCheck or false;
      doInstallCheck = args.doInstallCheck or finalAttrs.doCheck;

      passthru = {
        effectiveVersion = lib.versions.majorMinor finalAttrs.version;
        siteCcacheDir = "lib/guile/site-ccache";
        siteDir = "share/guile/site";
      };

      meta = args.meta or { } // {
        homepage = "https://www.gnu.org/software/guile/";
        description = "Embeddable Scheme implementation";
        mainProgram = "guile";
        longDescription = ''
          GNU Guile is an implementation of the Scheme programming language, with
          support for many SRFIs, packaged for use in a wide variety of
          environments.  In addition to implementing the R5RS Scheme standard and a
          large subset of R6RS, Guile includes a module system, full access to POSIX
          system calls, networking support, multiple threads, dynamic linking, a
          foreign function call interface, and powerful string processing.
        '';
        license = lib.licenses.lgpl3Plus;
        platforms = lib.platforms.all;
      };
    };
}
