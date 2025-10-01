{
  lib,
  stdenv,
  fetchurl,
  pkgsBuildBuild,
  gawk,
  gmp,
  libtool,
  makeBinaryWrapper,
  pkg-config,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile";
  version = "1.8.8";

  src = fetchurl {
    url = "mirror://gnu/guile/guile-${finalAttrs.version}.tar.gz";
    hash = "sha256-w0cf7S5y5bBK0TO7qvFjaeg2AoNnm88ZgAvBs4ECQFA=";
  };

  patches = [
    # Fix doc snarfing with GCC 4.5.
    ./cpp-4.5.patch
    # Self explanatory
    ./CVE-2016-8605.patch
  ];

  postPatch = ''
    sed -e '/lt_dlinit/a  lt_dladdsearchdir("'$out/lib'");' -i libguile/dynl.c
  '';

  outputs = [
    "out"
    "dev"
    "info"
  ];

  setOutputFlags = false; # $dev gets into the library otherwise

  # GCC 4.6 raises a number of set-but-unused warnings.
  configureFlags = [
    "--disable-error-on-warning"
    "AWK=${lib.getExe gawk}"
  ]
  # Guile needs patching to preset results for the configure tests about
  # pthreads, which work only in native builds.
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--with-threads=no";

  strictDeps = true;
  depsBuildBuild = [
    pkgsBuildBuild.stdenv.cc
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) pkgsBuildBuild.guile_1_8;

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libtool
    readline
  ];

  propagatedBuildInputs = [
    gmp

    # XXX: These ones aren't normally needed here, but `libguile*.la' has '-l'
    # flags for them without corresponding '-L' flags. Adding them here will add
    # the needed `-L' flags.  As for why the `.la' file lacks the `-L' flags,
    # see below.
    libtool
  ];

  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  postInstall = ''
    substituteInPlace "out/lib/pkgconfig/guile"-*.pc \
      --replace-fail "-lltdl" "-L${libtool.lib}/lib -lltdl"
  '';

  # One test fails.
  # ERROR: file: "libtest-asmobs", message: "file not found"
  # This is fixed here:
  # <https://git.savannah.gnu.org/cgit/guile.git/commit/?h=branch_release-1-8&id=a0aa1e5b69d6ef0311aeea8e4b9a94eae18a1aaf>.
  doCheck = false;
  doInstallCheck = finalAttrs.doCheck;

  setupHook = ./setup-hook-1.8.sh;

  passthru = {
    effectiveVersion = lib.versions.majorMinor finalAttrs.version;
    siteCcacheDir = "lib/guile/site-ccache";
    siteDir = "share/guile/site";
  };

  meta = {
    homepage = "https://www.gnu.org/software/guile/";
    description = "Embeddable Scheme implementation";
    longDescription = ''
      GNU Guile is an implementation of the Scheme programming language, with
      support for many SRFIs, packaged for use in a wide variety of
      environments.  In addition to implementing the R5RS Scheme standard and a
      large subset of R6RS, Guile includes a module system, full access to POSIX
      system calls, networking support, multiple threads, dynamic linking, a
      foreign function call interface, and powerful string processing.
    '';
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ ludo ];
    platforms = lib.platforms.all;
  };
})
