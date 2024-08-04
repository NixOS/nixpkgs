{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  pname = "pid";
  version = "3.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e33670e83f6a33ebb0822e43a609c3247178d4a375ff50a4689e266d853eb66";
  };

  buildInputs = [ nose ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Pidfile featuring stale detection and file-locking";
    homepage = "https://github.com/trbs/pid/";
    license = licenses.asl20;
  };
}
