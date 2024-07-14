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
    hash = "sha256-DjNnDoP2oz67CCLkOmCcMkcXjUo3X/UKRoniZthT62Y=";
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
