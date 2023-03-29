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
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-CFLqlHrTwQzCvpPAtQigCVL3Fs8V05Tmh6nkEsnaV2I=";
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
