{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "appnope";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71";
  };

  meta = {
    description = "Disable App Nap on macOS";
    homepage    = https://pypi.python.org/pypi/appnope;
    platforms   = lib.platforms.darwin;
    license     = lib.licenses.bsd3;
  };
}