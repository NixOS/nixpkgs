{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ptyprocess";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e64193f0047ad603b71f202332ab5527c5e52aa7c8b609704fc28c0dc20c4365";
  };

  meta = {
    description = "Run a subprocess in a pseudo terminal";
    homepage = https://github.com/pexpect/ptyprocess;
    license = lib.licenses.isc;
  };
}
