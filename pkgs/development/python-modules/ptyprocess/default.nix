{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ptyprocess";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dcb78fb2197b49ca1b7b2f37b047bc89c0da7a90f90bd5bc17c3ce388bb6ef59";
  };

  meta = {
    description = "Run a subprocess in a pseudo terminal";
    homepage = https://github.com/pexpect/ptyprocess;
    license = lib.licenses.isc;
  };
}
