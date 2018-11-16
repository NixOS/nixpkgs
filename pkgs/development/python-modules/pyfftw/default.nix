{ stdenv, buildPythonPackage, fetchPypi
, fftw, fftwFloat, fftwLongDouble, numpy, scipy }:

buildPythonPackage rec {
  version = "0.10.4";
  pname = "pyFFTW";

  src = fetchPypi {
    inherit pname version;
    sha256 = "739b436b7c0aeddf99a48749380260364d2dc027cf1d5f63dafb5f50068ede1a";
  };

  buildInputs = [ fftw fftwFloat fftwLongDouble];

  propagatedBuildInputs = [ numpy scipy ];

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
