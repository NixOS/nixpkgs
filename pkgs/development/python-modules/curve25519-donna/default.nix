{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "curve25519-donna";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GBip1TVqBcAizVBPRP4dL2QaXAIPikxRsilOAr2cG/A=";
  };

  meta = with lib; {
    description = "Python wrapper for the portable curve25519-donna implementation";
    homepage = "http://code.google.com/p/curve25519-donna/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
