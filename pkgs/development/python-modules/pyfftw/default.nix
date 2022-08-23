{ lib, buildPythonPackage, fetchPypi
, fftw, fftwFloat, fftwLongDouble, numpy, scipy, cython, dask }:

buildPythonPackage rec {
  version = "0.13.0";
  pname = "pyFFTW";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da85102405c0bd95d57eb19e99b01a0729d8406cb204c3900894b873784253da";
  };

  preConfigure = ''
    export LDFLAGS="-L${fftw.out}/lib -L${fftwFloat.out}/lib -L${fftwLongDouble.out}/lib"
    export CFLAGS="-I${fftw.dev}/include -I${fftwFloat.dev}/include -I${fftwLongDouble.dev}/include"
  '';

  buildInputs = [ fftw fftwFloat fftwLongDouble];

  propagatedBuildInputs = [ numpy scipy cython dask ];

  # Tests cannot import pyfftw. pyfftw works fine though.
  doCheck = false;
  pythonImportsCheck = [ "pyfftw" ];

  meta = with lib; {
    description = "A pythonic wrapper around FFTW, the FFT library, presenting a unified interface for all the supported transforms";
    homepage = "http://hgomersall.github.com/pyFFTW/";
    license = with licenses; [ bsd2 bsd3 ];
    maintainers = with maintainers; [ fridh ];
  };
}
