{ stdenv
, pkgs
, lib
# Note: either stdenv.mkDerivation or, for octaveFull, the qt-5 mkDerivation
# with wrapQtAppsHook (comes from libsForQt5.callPackage)
, mkDerivation
, fetchurl
, gfortran
, ncurses
, perl
, flex
, texinfo
, qhull
, libsndfile
, portaudio
, libX11
, graphicsmagick
, pcre2
, pkg-config
, libGL
, libGLU
, fltk
# Both are needed for discrete Fourier transform
, fftw
, fftwSinglePrec
, zlib
, curl
, rapidjson
, blas, lapack
# These two should use the same lapack and blas as the above
, qrupdate, arpack, suitesparse ? null
# If set to true, the above 5 deps are overridden to use the blas and lapack
# with 64 bit indexes support. If all are not compatible, the build will fail.
, use64BitIdx ? false
, libwebp
, gl2ps
, ghostscript ? null
, hdf5 ? null
, glpk ? null
, gnuplot ? null
# - Include support for GNU readline:
, enableReadline ? true
, readline ? null
# - Build Java interface:
, enableJava ? true
, jdk ? null
, python ? null
, overridePlatforms ? null
, sundials ? null
# - Packages required for building extra packages.
, newScope
, callPackage
, makeSetupHook
, makeWrapper
# - Build Octave Qt GUI:
, enableQt ? false
, qtbase ? null
, qtsvg ? null
, qtscript ? null
, qscintilla ? null
, qttools ? null
, libiconv
, darwin
}:

let

  # Not always evaluated
  blas' = if use64BitIdx then
    blas.override {
      isILP64 = true;
    }
  else
    blas
  ;
  lapack' = if use64BitIdx then
    lapack.override {
      isILP64 = true;
    }
  else
    lapack
  ;
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
  # Not always suitesparse is required at all
  suitesparse' = if suitesparse != null then
    suitesparse.override {
      blas = blas';
      lapack = lapack';
    }
  else
    null
  ;

  octavePackages = import ../../../top-level/octave-packages.nix {
    inherit pkgs;
    inherit lib stdenv fetchurl newScope;
    octave = self;
  };

  wrapOctave = callPackage ./wrap-octave.nix {
    octave = self;
    inherit (pkgs) makeSetupHook makeWrapper;
  };

  self = mkDerivation rec {
    version = "8.2.0";
    pname = "octave";

    src = fetchurl {
      url = "mirror://gnu/octave/${pname}-${version}.tar.gz";
      sha256 = "sha256-V9F/kYqUDTjKM0ghHhELNNc1oyKofbccF3xGkqSanIQ=";
    };

    buildInputs = [
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
    ]
    ++ lib.optionals enableQt [
      qtbase
      qtsvg
      qscintilla
    ]
    ++ lib.optionals (ghostscript != null) [ ghostscript ]
    ++ lib.optionals (hdf5 != null) [ hdf5 ]
    ++ lib.optionals (glpk != null) [ glpk ]
    ++ lib.optionals (suitesparse != null) [ suitesparse' ]
    ++ lib.optionals (enableJava) [ jdk ]
    ++ lib.optionals (sundials != null) [ sundials ]
    ++ lib.optionals (gnuplot != null) [ gnuplot ]
    ++ lib.optionals (python != null) [ python ]
    ++ lib.optionals (!stdenv.isDarwin) [ libGL libGLU libX11 ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Accelerate
      darwin.apple_sdk.frameworks.Cocoa
    ]
    ;
    nativeBuildInputs = [
      pkg-config
      gfortran
      # Listed here as well because it's outputs are split
      fftw
      fftwSinglePrec
      texinfo
    ]
    ++ lib.optionals (sundials != null) [ sundials ]
    ++ lib.optionals enableQt [
      qtscript
      qttools
    ]
    ;

    doCheck = !stdenv.isDarwin;

    enableParallelBuilding = true;

    # Fix linker error on Darwin (see https://trac.macports.org/ticket/61865)
    NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lobjc";

    # See https://savannah.gnu.org/bugs/?50339
    F77_INTEGER_8_FLAG = lib.optionalString use64BitIdx "-fdefault-integer-8";

    configureFlags = [
      "--with-blas=blas"
      "--with-lapack=lapack"
      (if use64BitIdx then "--enable-64" else "--disable-64")
    ]
    ++ lib.optionals stdenv.isDarwin [ "--enable-link-all-dependencies" ]
    ++ lib.optionals enableReadline [ "--enable-readline" ]
    ++ lib.optionals stdenv.isDarwin [ "--with-x=no" ]
    ++ lib.optionals enableQt [ "--with-qt=5" ]
    ;

    # Keep a copy of the octave tests detailed results in the output
    # derivation, because someone may care
    postInstall = ''
      cp test/fntests.log $out/share/octave/${pname}-${version}-fntests.log || true
    '';

    passthru = rec {
      sitePath = "share/octave/${version}/site";
      octPkgsPath = "share/octave/octave_packages";
      blas = blas';
      lapack = lapack';
      qrupdate = qrupdate';
      arpack = arpack';
      suitesparse = suitesparse';
      inherit fftw fftwSinglePrec;
      inherit portaudio;
      inherit jdk;
      inherit python;
      inherit enableQt enableReadline enableJava;
      buildEnv = callPackage ./build-env.nix {
        octave = self;
        inherit octavePackages wrapOctave;
        inherit (octavePackages) computeRequiredOctavePackages;
      };
      withPackages = import ./with-packages.nix { inherit buildEnv octavePackages; };
      pkgs = octavePackages;
      interpreter = "${self}/bin/octave";
    };

    meta = {
      homepage = "https://www.gnu.org/software/octave/";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ raskin doronbehar ];
      description = "Scientific Programming Language";
      platforms = if overridePlatforms == null then
        (lib.platforms.linux ++ lib.platforms.darwin)
      else overridePlatforms;
    };
  };

in self
