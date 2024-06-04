{
  lib,
  buildPythonPackage,
  fetchPypi,
  fftw,
  fftwFloat,
  fftwLongDouble,
  numpy,
  scipy,
  cython_0,
  dask,
}:

buildPythonPackage rec {
  version = "0.13.1";
  pname = "pyFFTW";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CRVekKDG0MHy0fNmgYCn3pX7n4P+9RN6ES+wWXjocyA=";
  };

  preConfigure = ''
    export LDFLAGS="-L${fftw.out}/lib -L${fftwFloat.out}/lib -L${fftwLongDouble.out}/lib"
    export CFLAGS="-I${fftw.dev}/include -I${fftwFloat.dev}/include -I${fftwLongDouble.dev}/include"
  '';

  buildInputs = [
    fftw
    fftwFloat
    fftwLongDouble
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    cython_0
    dask
  ];

  # Tests cannot import pyfftw. pyfftw works fine though.
  doCheck = false;
  pythonImportsCheck = [ "pyfftw" ];

  meta = with lib; {
    description = "A pythonic wrapper around FFTW, the FFT library, presenting a unified interface for all the supported transforms";
    homepage = "http://hgomersall.github.com/pyFFTW/";
    license = with licenses; [
      bsd2
      bsd3
    ];
  };
}
