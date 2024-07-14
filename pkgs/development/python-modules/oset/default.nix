{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "oset";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TB/X3slu7/nTJgmVqON/n0FdC9t5l19Xgk5ocWrI+QQ=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Ordered set";
    license = licenses.psfl;
  };
}
