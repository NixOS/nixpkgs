{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, libcxx
, cppy
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc4453705b81d03568d5b808ad8f09c77c47534f6ac2e72e733f9ca4714aa75c";
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
