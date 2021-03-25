{ lib, buildPythonPackage, isPy3k, fetchPypi, stdenv, exiv2, boost, libcxx, substituteAll, python }:

buildPythonPackage rec {
  pname = "py3exiv2";
  version = "0.8.0";
  disabled = !(isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v419f1kkqw8hqyc3yhzslnbzk52j8j3wfknfkjg308n5mf5bn09";
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
