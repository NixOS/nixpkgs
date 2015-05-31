{ stdenv, fetchurl, gfortran, readline, ncurses, perl, flex, texinfo, qhull
, libX11, graphicsmagick, pcre, liblapack, pkgconfig, mesa, fltk
, fftw, fftwSinglePrec, zlib, curl, qrupdate
, qt ? null, qscintilla ? null, ghostscript ? null, llvm ? null, hdf5 ? null,glpk ? null
, suitesparse ? null, gnuplot ? null, jdk ? null, python ? null
}:

stdenv.mkDerivation rec {
  version = "4.0.0";
  name = "octave-${version}";
  src = fetchurl {
    url = "mirror://gnu/octave/${name}.tar.xz";
    sha256 = "0x64b2lna4vrlm4wwx6h1qdlmki6s2b9q90yjxldlvvrqvxf4syg";
  };

  buildInputs = [ gfortran readline ncurses perl flex texinfo qhull libX11
    graphicsmagick pcre liblapack pkgconfig mesa fltk zlib curl
    fftw fftwSinglePrec qrupdate ]
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
    ;

  # there is a mysterious sh: command not found
  doCheck = false;

  # problems on Hydra
  enableParallelBuilding = false;

  configureFlags = [ "--enable-readline" "--enable-dl" ];

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
    platforms = with stdenv.lib.platforms; linux;
  };
}
