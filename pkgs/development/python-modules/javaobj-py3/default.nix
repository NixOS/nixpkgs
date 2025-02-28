{
  buildPythonPackage,
  fetchPypi,
  isPy27,
  lib,
  numpy,
}:

buildPythonPackage rec {
  pname = "javaobj-py3";
  version = "0.4.4";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5OMlfvLPgaMzl4ek1c+STlTJHwlacj9tJYTa5h1Dlu0=";
  };

  propagatedBuildInputs = [ numpy ];

  # Tests assume network connectivity
  doCheck = false;

  pythonImportsCheck = [ "javaobj" ];

  meta = with lib; {
    description = "Module for serializing and de-serializing Java objects";
    homepage = "https://github.com/tcalmant/python-javaobj";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
