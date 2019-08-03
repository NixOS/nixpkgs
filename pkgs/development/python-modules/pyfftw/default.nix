{ stdenv, buildPythonPackage, fetchPypi
, fftw, fftwFloat, fftwLongDouble, numpy, scipy, cython, dask }:

buildPythonPackage rec {
  version = "0.11.1";
  pname = "pyFFTW";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05ea28dede4c3aaaf5c66f56eb0f71849d0d50f5bc0f53ca0ffa69534af14926";
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
