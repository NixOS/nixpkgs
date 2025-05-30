{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,

  fftw,
  fftwFloat,
  fftwLongDouble,
  cython,

  numpy,
}:

buildPythonPackage rec {
  pname = "pyfftw";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j9aar9n1e1Pr8NC+lDMsj2U0nFw88lX/XYQ2GdYoshw=";
  };

  disabled = pythonOlder "3.9";

  build-system = [ setuptools ];

  buildInputs = [
    fftw
    fftwFloat
    fftwLongDouble
    cython
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "pyfftw" ];

  meta = with lib; {
    description = "Pythonic wrapper around FFTW 3, the speedy FFT library";
    homepage = "https://github.com/pyFFTW/pyFFTW";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
