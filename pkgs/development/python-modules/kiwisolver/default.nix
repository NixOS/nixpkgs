{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, libcxx
, cppy
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "950a199911a8d94683a6b10321f9345d5a3a8433ec58b217ace979e18f16e248";
  };

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  nativeBuildInputs = [
    cppy
  ];

  # Does not include tests
  doCheck = false;

  meta = {
    description = "A fast implementation of the Cassowary constraint solver";
    homepage = "https://github.com/nucleic/kiwi";
    license = lib.licenses.bsd3;
  };

}
