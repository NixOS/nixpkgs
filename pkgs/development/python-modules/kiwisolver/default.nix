{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, libcxx
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53eaed412477c836e1b9522c19858a8557d6e595077830146182225613b11a75";
  };
  
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";
  
  # Does not include tests
  doCheck = false;

  meta = {
    description = "A fast implementation of the Cassowary constraint solver";
    homepage = https://github.com/nucleic/kiwi;
    license = lib.licenses.bsd3;
  };

}
