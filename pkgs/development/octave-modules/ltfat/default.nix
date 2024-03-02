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
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/ltfat/ltfat/releases/download/v${version}/${pname}-${version}-of.tar.gz";
    sha256 = "sha256-FMDZ8XFhLG7KDoUjtXvafekg6tSltwBaO0+//jMzJj4=";
  };

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
