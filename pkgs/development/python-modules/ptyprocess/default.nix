{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ptyprocess";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220";
  };

  meta = {
    description = "Run a subprocess in a pseudo terminal";
    homepage = "https://github.com/pexpect/ptyprocess";
    license = lib.licenses.isc;
  };
}
