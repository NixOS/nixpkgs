{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "kiwisolver";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce3be5d520b4d2c3e5eeb4cd2ef62b9b9ab8ac6b6fedbaa0e39cdb6f50644278";
  };

  # Does not include tests
  doCheck = false;

  meta = {
    description = "A fast implementation of the Cassowary constraint solver";
    homepage = https://github.com/nucleic/kiwi;
    license = lib.licenses.bsd3;
  };

}