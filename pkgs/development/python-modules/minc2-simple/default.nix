{ buildPythonPackage, fetchFromGitHub, stdenv, cmake,
  hdf5, libminc, minc2_simple, minc_tools, mni_autoreg,
  cffi, six, numpy, scipy, pytest }:

buildPythonPackage {
  pname   = "minc2-simple";

  inherit (minc2_simple) version src;

  sourceRoot = "source/python";

  buildInputs = [ cffi six numpy scipy hdf5 libminc minc2_simple ];
  checkInputs = [ pytest minc_tools mni_autoreg ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/vfonov/minc2-simple";
    description = "Simple interface to the libminc medical imaging library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license   = licenses.free;
  };
}
