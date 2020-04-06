{ stdenv, buildPythonPackage, fetchPypi
, fftw, fftwFloat, fftwLongDouble, numpy, scipy, cython, dask }:

buildPythonPackage rec {
  version = "0.12.0";
  pname = "pyFFTW";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60988e823ca75808a26fd79d88dbae1de3699e72a293f812aa4534f8a0a58cb0";
  };

  buildInputs = [ fftw fftwFloat fftwLongDouble];

  propagatedBuildInputs = [ numpy scipy cython dask ];

  # Tests cannot import pyfftw. pyfftw works fine though.
  doCheck = false;

  preConfigure = ''
    export LDFLAGS="-L${fftw.out}/lib -L${fftwFloat.out}/lib -L${fftwLongDouble.out}/lib"
    export CFLAGS="-I${fftw.dev}/include -I${fftwFloat.dev}/include -I${fftwLongDouble.dev}/include"
  '';
  #+ optionalString isDarwin ''
  #  export DYLD_LIBRARY_PATH="${pkgs.fftw.out}/lib"
  #'';

  meta = with stdenv.lib; {
    description = "A pythonic wrapper around FFTW, the FFT library, presenting a unified interface for all the supported transforms";
    homepage = http://hgomersall.github.com/pyFFTW/;
    license = with licenses; [ bsd2 bsd3 ];
    maintainers = with maintainers; [ fridh ];
  };
}
