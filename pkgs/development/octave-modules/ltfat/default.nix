{ buildOctavePackage
, lib
, fetchurl
, fftw
, fftwSinglePrec
, fftwFloat
, fftwLongDouble
, lapack
, blas
, portaudio
, jdk
}:

buildOctavePackage rec {
  pname = "ltfat";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0gghh5a4w649ff776wvidfvqas87m0n7rqs960pid1d11bnyqqrh";
  };

  patches = [
    # Fixes a syntax error with performing multiplication.
    ./syntax-error.patch
  ];

  buildInputs = [
    fftw
    fftwSinglePrec
    fftwFloat
    fftwLongDouble
    lapack
    blas
    portaudio
    jdk
  ];

  meta = with lib; {
    name = "The Large Time-Frequency Analysis Toolbox";
    homepage = "https://octave.sourceforge.io/ltfat/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Toolbox for working with time-frequency analysis, wavelets and signal processing";
    longDescription = ''
      The Large Time/Frequency Analysis Toolbox (LTFAT) is a Matlab/Octave
      toolbox for working with time-frequency analysis, wavelets and signal
      processing. It is intended both as an educational and a computational
      tool. The toolbox provides a large number of linear transforms including
      Gabor and wavelet transforms along with routines for constructing windows
      (filter prototypes) and routines for manipulating coefficients.
    '';
  };
}
