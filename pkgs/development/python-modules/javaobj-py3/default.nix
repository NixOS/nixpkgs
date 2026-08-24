{
  buildPythonPackage,
  fetchPypi,
  lib,
  numpy,
}:

buildPythonPackage rec {
  pname = "javaobj-py3";
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CI/whsaqKRLzQnVMQ7DKOlBPuGm7Xm8TOVEx6HdE7zw=";
  };

  propagatedBuildInputs = [ numpy ];

  # Tests assume network connectivity
  doCheck = false;

  pythonImportsCheck = [ "javaobj" ];

  meta = {
    description = "Module for serializing and de-serializing Java objects";
    homepage = "https://github.com/tcalmant/python-javaobj";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
