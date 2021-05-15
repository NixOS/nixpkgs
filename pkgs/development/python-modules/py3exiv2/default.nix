{ lib, buildPythonPackage, isPy3k, fetchPypi, stdenv, exiv2, boost, libcxx, substituteAll, python }:

buildPythonPackage rec {
  pname = "py3exiv2";
  version = "0.9.3";
  disabled = !(isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "838836e58ca22557d83d1f0ef918bcce899b4c2666340b924b940dcdebf1d18c";
  };

  buildInputs = [ exiv2 boost ];

  # work around python distutils compiling C++ with $CC (see issue #26709)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  meta = with lib; {
    homepage = "https://launchpad.net/py3exiv2";
    description = "A Python3 binding to the library exiv2";
    license = licenses.gpl3;
    maintainers = with maintainers; [ vinymeuh ];
    platforms = with platforms; linux ++ darwin;
  };
}
