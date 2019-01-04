{ buildPythonPackage, fetchFromGitHub, stdenv, cmake,
  hdf5, libminc, minc2_simple, minc_tools, mni_autoreg,
  cffi, six, numpy, scipy, pytest }:

buildPythonPackage rec {
  name     = "minc2-simple-${version}";
  version  = "2018-12-20";

  src = fetchFromGitHub {
    owner  = "vfonov";
    repo   = "minc2-simple";
    rev    = "e04414eb74052d8a6f9fb4bedda7f0894e86ac82";
    sha256 = "1miy942ibbcikg0k45d7342ags2gpr29rvhvspwxqgv2jnpcwg05";
  };

  checkInputs = [ pytest minc_tools mni_autoreg ];
  buildInputs = [ cffi six numpy scipy hdf5 libminc minc2_simple ];

  preConfigure = "cd python";

  meta = with stdenv.lib; {
    homepage = "https://github.com/vfonov/minc2-simple";
    description = "Simple interface to the libminc medical imaging library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license   = licenses.free;
  };
}
