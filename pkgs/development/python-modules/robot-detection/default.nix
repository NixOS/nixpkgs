{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "robot-detection";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PY+3LKRxZLjOVeM73ak3QvYsNI3vfTzDtCsM60eVovU=";
  };

  propagatedBuildInputs = [ six ];

  # no tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Library for detecting if a HTTP User Agent header is likely to be a bot";
    homepage = "https://github.com/rory/robot-detection";
    license = licenses.gpl3Plus;
  };
}
