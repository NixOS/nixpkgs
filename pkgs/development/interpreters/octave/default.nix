{
  stdenv,
  pkgs,
  config,
  lib,
  fetchurl,
  gfortran,
  ncurses,
  perl,
  flex,
  testers,
  texinfo,
  qhull,
  libsndfile,
  portaudio,
  libx11,
  graphicsmagick,
  pcre2,
  pkg-config,
  libGL,
  libGLU,
  fltk,
  # Both are needed for discrete Fourier transform
  fftw,
  fftwSinglePrec,
  fast-float,
  zlib,
  curl,
  rapidjson,
  blas,
  lapack,
  # These 3 should use the same lapack and blas as the above, see code prepending
  qrupdate,
  arpack,
  suitesparse,
  # If set to true, the above 5 deps are overridden to use the blas and lapack
  # with 64 bit indexes support. If all are not compatible, the build will fail.
  use64BitIdx ? false,
  libwebp,
  gl2ps,
  ghostscript,
  hdf5,
  glpk,
  gnuplot,
  # - Include support for GNU readline:
  enableReadline ? true,
  readline,
  # - Build Java interface:
  enableJava ? true,
  jdk,
  python3,
  sundials,
  # - Packages required for building extra packages.
  newScope,
  callPackage,
  # - Build Octave Qt GUI:
  enableQt ? false,
  qt6Packages,
  libiconv,

  # tests
  writableTmpDirAsHomeHook,
  makeFontsConf,
}:

let
  # Not always evaluated
  blas' =
    if use64BitIdx then
      blas.override {
        isILP64 = true;
      }
    else
      blas;
  lapack' =
    if use64BitIdx then
      lapack.override {
        isILP64 = true;
      }
    else
      lapack;
  qrupdate' = qrupdate.override {
    # If use64BitIdx is false, this override doesn't evaluate to a new
    # derivation, as blas and lapack are not overridden.
    blas = blas';
    lapack = lapack';
  };
  arpack' = arpack.override {
    blas = blas';
    lapack = lapack';
  };
  # We keep the option to not enable suitesparse support by putting it null
  suitesparse' =
    if suitesparse != null then
      suitesparse.override {
        blas = blas';
        lapack = lapack';
      }
    else
      null;
  # To avoid confusion later in passthru
  allPkgs = pkgs;
in
stdenv.mkDerivation (finalAttrs: {
  version = "11.3.0";
  pname = "octave";

  src = fetchurl {
    url = "mirror://gnu/octave/octave-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-y1if6zzvhNE0hUaDcYycE+C0ceqRbQdhvnqMTiYaMtE=";
  };

  postPatch = ''
    patchShebangs --build build-aux/*.pl
  '';

  buildInputs = [
    readline
    ncurses
    flex
    qhull
    graphicsmagick
    pcre2
    fltk
    zlib
    curl
    rapidjson
    blas'
    lapack'
    libsndfile
    fftw
    fftwSinglePrec
    portaudio
    qrupdate'
    arpack'
    libwebp
    gl2ps
    ghostscript
    hdf5
    glpk
    suitesparse'
    sundials
    gnuplot
    python3
  ]
  ++ lib.optionals enableQt [
    qt6Packages.qtbase
    qt6Packages.qtsvg
    qt6Packages.qt5compat
    qt6Packages.qscintilla
  ]
  ++ lib.optionals enableJava [
    jdk
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libGLU
    libx11
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fast-float
  ];
  nativeBuildInputs = [
    perl
    pkg-config
    gfortran
    texinfo
  ]
  ++ lib.optionals enableQt [
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  # When built with Qt support, Qt's platform integration probes Wayland at
  # startup, which gives a harmless, but slightly spamming error:
  #
  #   XDG_RUNTIME_DIR is invalid or not set in the environment
  preCheck = lib.optionalString enableQt ''
    export XDG_RUNTIME_DIR=$TMPDIR
  '';

  enableParallelBuilding = true;

  env = {
    # gnuplot (invoked by the test suite) requires a fontconfig config
    # file to exist, or else it errors with "Fontconfig error: Cannot
    # load default config file: File not found". No fonts are actually
    # needed to avoid this.
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };
    # gnuplot's degree sign handling requires a UTF-8 locale, or else it
    # errors with "warning: iconv failed to convert degree sign".
    # C.UTF-8 is built into glibc itself, so no extra locale-archive
    # dependency is needed.
    LC_ALL = "C.UTF-8";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Fix linker error on Darwin (see https://trac.macports.org/ticket/61865)
    NIX_LDFLAGS = "-lobjc";
    # https://savannah.gnu.org/bugs/index.php?68042
    NIX_CFLAGS_COMPILE = "-Wno-format-security";
  }
  // lib.optionalAttrs use64BitIdx {
    # See https://savannah.gnu.org/bugs/?50339
    F77_INTEGER_8_FLAG = "-fdefault-integer-8";
  };

  # Otherwise `qhelpgenerator` executable is not detected, and Qt support is
  # not enabled.
  preConfigure = ''
    export PATH="$PATH:${qt6Packages.qttools}/libexec"
  '';

  configureFlags = [
    (lib.withFeatureAs true "blas" "blas")
    (lib.withFeatureAs true "lapack" "lapack")
    (lib.enableFeature use64BitIdx "64")
    (lib.enableFeature enableReadline "readline")
    (lib.withFeatureAs enableQt "qt" (lib.versions.major qt6Packages.qtbase.version))
  ]
  # Ideally octave would have realized by itself that x is irrelevant for
  # darwin, but from some reason without this flag the build fails with a
  # compilation error:
  #
  #    In file included from libinterp/dldfcn/__init_fltk__.cc:74:
  #    In file included from /nix/store/3r8msa1x0x08rgf075vig01w1i2lkbhm-fltk-1.3.11/include/FL/fl_draw.H:27:
  #    In file included from /nix/store/3r8msa1x0x08rgf075vig01w1i2lkbhm-fltk-1.3.11/include/FL/x.H:30:
  #    /nix/store/3r8msa1x0x08rgf075vig01w1i2lkbhm-fltk-1.3.11/include/FL/mac.H:32:25: error: typedef redefinition with different types ('class FLWindow *' vs 'XID' (aka 'unsigned long'))
  #       32 | typedef class FLWindow *Window; // pointer to the FLWindow objective-c class
  #          |                         ^
  #    /nix/store/mqyaq13d0h4c8hia4bjgpn02by26nb8q-xorgproto-2025.1/include/X11/X.h:96:13: note: previous definition is here
  #       96 | typedef XID Window;
  #          |             ^
  #      CXX      libinterp/dldfcn/__init_gnuplot___la-__init_gnuplot__.lo
  #    1 error generated.
  #
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--with-x=no" ];

  # Keep a copy of the octave tests detailed results in the output
  # derivation, because someone may care
  postInstall = ''
    cp test/fntests.log $out/share/octave/octave-${finalAttrs.version}-fntests.log || true
  '';

  passthru = rec {
    sitePath = "share/octave/${finalAttrs.version}/site";
    octPkgsPath = "share/octave/octave_packages";
    blas = blas';
    lapack = lapack';
    qrupdate = qrupdate';
    arpack = arpack';
    suitesparse = suitesparse';
    octavePackages = import ../../../top-level/octave-packages.nix {
      pkgs = allPkgs;
      inherit
        config
        lib
        stdenv
        fetchurl
        newScope
        ;
      octave = finalAttrs.finalPackage;
    };
    wrapOctave = callPackage ./wrap-octave.nix {
      octave = finalAttrs.finalPackage;
      inherit (allPkgs) makeSetupHook makeWrapper;
    };
    inherit fftw fftwSinglePrec;
    inherit portaudio;
    inherit jdk;
    python = python3;
    inherit enableQt enableReadline enableJava;
    buildEnv = callPackage ./build-env.nix {
      octave = finalAttrs.finalPackage;
      inherit wrapOctave;
      inherit (octavePackages) computeRequiredOctavePackages;
    };
    withPackages = import ./with-packages.nix { inherit buildEnv octavePackages; };
    pkgs = octavePackages;
    interpreter = "${finalAttrs.finalPackage}/bin/octave";
    tests = {
      wrapper = testers.testVersion {
        package = finalAttrs.finalPackage.withPackages (ps: [ ps.doctest ]);
        command = "octave --version";
      };
    };
  };

  meta = {
    homepage = "https://www.gnu.org/software/octave/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      doronbehar
    ];
    description = "Scientific Programming Language";
  };
})
