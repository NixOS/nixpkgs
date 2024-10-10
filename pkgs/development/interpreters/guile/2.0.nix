{ lib
, autoreconfHook
, boehmgc
, buildPackages
, coverageAnalysis ? null
, fetchpatch2
, fetchFromSavannah
, flex
, gawk
, gmp
, libffi
, libtool
, libunistring
, makeWrapper
, pkg-config
, pkgsBuildBuild
, readline
, stdenv
, texinfo
# Boolean flags
, runCoverageAnalysis ? false
}:

let
  pname = "guile";
  version = "2.0.13";
  src = fetchFromSavannah {
    repo = "guile";
    rev = "v${version}";
    hash = "sha256-aImjL3T1NkSlXVeykd5dMHhQc4gzPKCkIZTSxKGgKeg=";
  };

  builder = if runCoverageAnalysis
            then coverageAnalysis
            else stdenv.mkDerivation;
in
assert runCoverageAnalysis -> (coverageAnalysis != null);
builder {
  inherit pname version src;

  outputs = [ "out" "dev" "info" ];

  patches = [
    # Small fixes to Clang compiler
    ./clang.patch
    # Self-explanatory
    ./disable-gc-sensitive-tests.patch
    # Read the header of the patch to more info
    ./eai_system.patch
    # RISC-V endianness
    ./riscv.patch
    # Fixes stability issues with 00-repl-server.test
    (fetchpatch2 {
      url = "https://git.savannah.gnu.org/cgit/guile.git/patch/?id=2fbde7f02adb8c6585e9baf6e293ee49cd23d4c4";
      hash = "sha256-y24XMuwe14esLF3wBZ0z1OLp1E8KfLjrN9R3lP8vzLo=";
    })] ++
  (lib.optionals runCoverageAnalysis [ ./gcov-file-name.patch ])
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./filter-mkostemp-darwin.patch
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
      hash = "sha256-DI9nIIyZtRAEV/jQQdHPVRthMBOkanjzi5SvavDL3qU=";
    })
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    pkgsBuildBuild.guile_2_0
  ];

  nativeBuildInputs = [
    autoreconfHook
    flex
    makeWrapper
    pkg-config
    texinfo
  ];

  buildInputs = [
    libffi
    libtool
    libunistring
    readline
  ];

  propagatedBuildInputs = [
    boehmgc
    gmp
    # These ones aren't normally needed here, but 'libguile*.la' has '-l' flags
    # for them without corresponding '-L' flags. Adding them here will add the
    # needed '-L' flags.
    # As for why the '.la' file lacks the '-L' flags, see below
    libtool
    libunistring
  ];

  configureFlags = [
    (lib.withFeature true "libreadline-prefix")
  ] ++ lib.optionals stdenv.hostPlatform.isSunOS [
    # Make sure the right <gmp.h> is found, and not the incompatible
    # /usr/include/mp.h from OpenSolaris
    # More details at
    # <https://lists.gnu.org/archive/html/hydra-users/2012-08/msg00000.html>
    (lib.withFeatureAs true "with-libgmp-prefix" "${lib.getDev gmp}")

    # Same for these (?)
    (lib.withFeatureAs true "libreadline-prefix" "${lib.getDev readline}")
    (lib.withFeatureAs true "libunistring-prefix" "${lib.getDev libunistring}")

    # See below
    (lib.withFeature false "threads")
  ];

  env = {
    # Explicitly link against libgcc_s, to work around the infamous
    # "libgcc_s.so.1 must be installed for pthread_cancel to work". However
    # there is no "libgcc_s.so.1" on darwin and musl
    LDFLAGS = lib.optionalString (!stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isMusl) "-lgcc_s";
    # Work around <https://bugs.gnu.org/14201>
    SHELL = lib.optionalString (!stdenv.hostPlatform.isLinux) stdenv.shell;
    CONFIG_SHELL = lib.optionalString (!stdenv.hostPlatform.isLinux) stdenv.shell;
  };

  enableParallelBuilding = true;

  setOutputFlags = false; # otherwise $dev gets into the library

  # make check doesn't work on darwin
  # On Linuxes+Hydra the tests are flaky; feel free to investigate deeper
  doCheck = false;

  doInstallCheck = false;

  postInstall = ''
    wrapProgram $out/bin/guile-snarf --prefix PATH : "${lib.getBin gawk}/bin"
  ''
  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why '--with-libunistring-prefix' and similar options coming from
  # 'AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64
  + ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc \
        -e "s|-lunistring|-L${lib.getLib libunistring}/lib -lunistring|g" \
        -e "s|^Cflags:\(.*\)$|Cflags: -I${lib.getDev libunistring}/include \1|g" \
        -e "s|-lltdl|-L${lib.getLib libtool}/lib -lltdl|g" \
        -e "s|includedir=$out|includedir=$dev|g"
    '';

  setupHook = ./setup-hook-2.0.sh;

  passthru = let
    effectiveVersion = lib.versions.majorMinor version;
  in
    {
      inherit effectiveVersion;
      siteCcacheDir = "lib/guile/${effectiveVersion}/site-ccache";
      siteDir = "share/guile/site/${effectiveVersion}";
    };

  meta = {
    homepage = "https://www.gnu.org/software/guile/";
    description = "Embeddable Scheme implementation";
    longDescription = ''
      GNU Guile is an implementation of the Scheme programming language, with
      support for many SRFIs, packaged for use in a wide variety of
      environments.

      In addition to implementing the R5RS Scheme standard and a large subset of
      R6RS, Guile includes a module system, full access to POSIX system calls,
      networking support, multiple threads, dynamic linking, a foreign function
      call interface, and powerful string processing.
    '';
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ ludo ];
    platforms = lib.platforms.all;
  };
}
# TODO: point to the proper coverageAnalysis input so we don't need to rely on
# setting it to null
