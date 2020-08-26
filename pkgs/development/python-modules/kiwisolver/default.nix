{ lib
, buildPythonPackage
, fetchPypi
, stdenv
, libcxx
, cppy
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "247800260cd38160c362d211dcaf4ed0f7816afb5efe56544748b21d6ad6d17f";
  };
  
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";
  
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
