{ stdenv
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
, pcre
, pkgconfig
, libGL
, libGLU
, fltk
# Both are needed for discrete Fourier transform
, fftw
, fftwSinglePrec
, zlib
, curl
, blas, lapack
# These two should use the same lapack and blas as the above
, qrupdate, arpack, suitesparse ? null
# If set to true, the above 5 deps are overriden to use the blas and lapack
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
# - Build Octave Qt GUI:
, enableQt ? false
, qtbase ? null
, qtsvg ? null
, qtscript ? null
, qscintilla ? null
, qttools ? null
# - JIT compiler for loops:
, enableJIT ? false
, llvm ? null
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
    # derivation, as blas and lapack are not overriden.
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
in mkDerivation rec {
  version = "6.1.0";
  pname = "octave";

  src = fetchurl {
    url = "mirror://gnu/octave/${pname}-${version}.tar.gz";
    sha256 = "0mqa1g3fq0q45mqc0didr8vl6bk7jzj6gjsf1522qqjq2r04xwvg";
  };

  buildInputs = [
    readline
    ncurses
    perl
    flex
    qhull
    graphicsmagick
    pcre
    fltk
    zlib
    curl
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
  ++ stdenv.lib.optionals enableQt [
    qtbase
    qtsvg
    qscintilla
  ]
  ++ stdenv.lib.optionals (ghostscript != null) [ ghostscript ]
  ++ stdenv.lib.optionals (hdf5 != null) [ hdf5 ]
  ++ stdenv.lib.optionals (glpk != null) [ glpk ]
  ++ stdenv.lib.optionals (suitesparse != null) [ suitesparse' ]
  ++ stdenv.lib.optionals (enableJava) [ jdk ]
  ++ stdenv.lib.optionals (sundials != null) [ sundials ]
  ++ stdenv.lib.optionals (gnuplot != null) [ gnuplot ]
  ++ stdenv.lib.optionals (python != null) [ python ]
  ++ stdenv.lib.optionals (!stdenv.isDarwin) [ libGL libGLU libX11 ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Accelerate
    darwin.apple_sdk.frameworks.Cocoa
  ]
  ;
  nativeBuildInputs = [
    pkgconfig
    gfortran
    # Listed here as well because it's outputs are split
    fftw
    fftwSinglePrec
    texinfo
  ]
  ++ stdenv.lib.optionals (sundials != null) [ sundials ]
  ++ stdenv.lib.optionals enableJIT [ llvm ]
  ++ stdenv.lib.optionals enableQt [
    qtscript
    qttools
  ]
  ;

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  # See https://savannah.gnu.org/bugs/?50339
  F77_INTEGER_8_FLAG = if use64BitIdx then "-fdefault-integer-8" else "";

  configureFlags = [
    "--with-blas=blas"
    "--with-lapack=lapack"
    (if use64BitIdx then "--enable-64" else "--disable-64")
  ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "--enable-link-all-dependencies" ]
    ++ stdenv.lib.optionals enableReadline [ "--enable-readline" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "--with-x=no" ]
    ++ stdenv.lib.optionals enableQt [ "--with-qt=5" ]
    ++ stdenv.lib.optionals enableJIT [ "--enable-jit" ]
  ;

  # Keep a copy of the octave tests detailed results in the output
  # derivation, because someone may care
  postInstall = ''
    cp test/fntests.log $out/share/octave/${pname}-${version}-fntests.log || true
  '';

  passthru = {
    sitePath = "share/octave/${version}/site";
    blas = blas';
    lapack = lapack';
    qrupdate = qrupdate';
    arpack = arpack';
    suitesparse = suitesparse';
    inherit python;
    inherit enableQt enableJIT enableReadline enableJava;
  };

  meta = {
    homepage = "https://www.gnu.org/software/octave/";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ raskin doronbehar ];
    description = "Scientific Pragramming Language";
    # https://savannah.gnu.org/bugs/?func=detailitem&item_id=56425 is the best attempt to fix JIT
    broken = enableJIT;
    platforms = if overridePlatforms == null then
      (with stdenv.lib; platforms.linux ++ platforms.darwin)
    else overridePlatforms;
  };
}
