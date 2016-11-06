{ stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull
, libsndfile, libX11, graphicsmagick, pcre, pkgconfig, mesa, fltk
, fftw, fftwSinglePrec, zlib, curl, qrupdate, openblas, arpack, libwebp
, qt ? null, qscintilla ? null, ghostscript ? null, llvm ? null, hdf5 ? null,glpk ? null
, suitesparse ? null, gnuplot ? null, jdk ? null, python ? null, overridePlatforms ? null
}:

let
  suitesparseOrig = suitesparse;
  qrupdateOrig = qrupdate;
in
# integer width is determined by openblas, so all dependencies must be built
# with exactly the same openblas
let
  suitesparse =
    if suitesparseOrig != null then suitesparseOrig.override { inherit openblas; } else null;
  qrupdate = if qrupdateOrig != null then qrupdateOrig.override { inherit openblas; } else null;
in

stdenv.mkDerivation rec {
  version = "4.0.1";
  name = "octave-${version}";
  src = fetchurl {
    url = "mirror://gnu/octave/${name}.tar.xz";
    sha256 = "11y2w6jgngj4rxiy136mkcs02l52rxk60kapyfc4rgrxz5hli3ym";
  };

  buildInputs = [ gfortran readline ncurses perl flex texinfo qhull
    graphicsmagick pcre pkgconfig fltk zlib curl openblas libsndfile fftw
    fftwSinglePrec qrupdate arpack libwebp ]
    ++ (stdenv.lib.optional (qt != null) qt)
    ++ (stdenv.lib.optional (qscintilla != null) qscintilla)
    ++ (stdenv.lib.optional (ghostscript != null) ghostscript)
    ++ (stdenv.lib.optional (llvm != null) llvm)
    ++ (stdenv.lib.optional (hdf5 != null) hdf5)
    ++ (stdenv.lib.optional (glpk != null) glpk)
    ++ (stdenv.lib.optional (suitesparse != null) suitesparse)
    ++ (stdenv.lib.optional (jdk != null) jdk)
    ++ (stdenv.lib.optional (gnuplot != null) gnuplot)
    ++ (stdenv.lib.optional (python != null) python)
    ++ (stdenv.lib.optionals (!stdenv.isDarwin) [ mesa libX11 ])
    ;

  doCheck = !stdenv.isDarwin;

  enableParallelBuilding = true;

  configureFlags =
    [ "--enable-readline"
      "--enable-dl"
      "--with-blas=openblas"
      "--with-lapack=openblas"
    ]
    ++ stdenv.lib.optional openblas.blas64 "--enable-64"
    ++ stdenv.lib.optionals stdenv.isDarwin ["--with-x=no"]
    ;

  # Keep a copy of the octave tests detailed results in the output
  # derivation, because someone may care
  postInstall = ''
    cp test/fntests.log $out/share/octave/${name}-fntests.log || true
  '';

  passthru = {
    inherit version;
    sitePath = "share/octave/${version}/site";
  };

  meta = {
    homepage = http://octave.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric raskin];
    platforms = if overridePlatforms == null then
      (with stdenv.lib.platforms; linux ++ darwin)
    else overridePlatforms;
  };
}
