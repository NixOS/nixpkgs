{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ptyprocess";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0";
  };

  meta = {
    description = "Run a subprocess in a pseudo terminal";
    homepage = "https://github.com/pexpect/ptyprocess";
    license = lib.licenses.isc;
  };
}
