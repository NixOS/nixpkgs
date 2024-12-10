{
  stdenv,
  pkgs,
  lib,
  fetchurl,
  gfortran,
  ncurses,
  perl,
  flex,
  texinfo,
  qhull,
  libsndfile,
  portaudio,
  libX11,
  graphicsmagick,
  pcre2,
  pkg-config,
  libGL,
  libGLU,
  fltk,
  # Both are needed for discrete Fourier transform
  fftw,
  fftwSinglePrec,
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
  makeSetupHook,
  makeWrapper,
  # - Build Octave Qt GUI:
  enableQt ? false,
  libsForQt5,
  libiconv,
  darwin,
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
  version = "8.4.0";
  pname = "octave";

  src = fetchurl {
    url = "mirror://gnu/octave/octave-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-azjdl1FnhCSus6nWZkMrHzeOs5caISkKkM09NRGdVq0=";
  };

  buildInputs =
    [
      readline
      ncurses
      perl
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
      libsForQt5.qtbase
      libsForQt5.qtsvg
      libsForQt5.qscintilla
    ]
    ++ lib.optionals (enableJava) [
      jdk
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      libGL
      libGLU
      libX11
    ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Accelerate
      darwin.apple_sdk.frameworks.Cocoa
    ];
  nativeBuildInputs =
    [
      pkg-config
      gfortran
      texinfo
    ]
    ++ lib.optionals enableQt [
      libsForQt5.wrapQtAppsHook
      libsForQt5.qtscript
      libsForQt5.qttools
    ];

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  # Fix linker error on Darwin (see https://trac.macports.org/ticket/61865)
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lobjc";

  # See https://savannah.gnu.org/bugs/?50339
  F77_INTEGER_8_FLAG = lib.optionalString use64BitIdx "-fdefault-integer-8";

  configureFlags =
    [
      "--with-blas=blas"
      "--with-lapack=lapack"
      (if use64BitIdx then "--enable-64" else "--disable-64")
    ]
    ++ lib.optionals stdenv.isDarwin [ "--enable-link-all-dependencies" ]
    ++ lib.optionals enableReadline [ "--enable-readline" ]
    ++ lib.optionals stdenv.isDarwin [ "--with-x=no" ]
    ++ lib.optionals enableQt [ "--with-qt=5" ];

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
      inherit octavePackages wrapOctave;
      inherit (octavePackages) computeRequiredOctavePackages;
    };
    withPackages = import ./with-packages.nix { inherit buildEnv octavePackages; };
    pkgs = octavePackages;
    interpreter = "${finalAttrs.finalPackage}/bin/octave";
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
