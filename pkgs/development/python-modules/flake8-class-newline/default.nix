{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  flake8,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flake8-class-newline";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UUxJI8iOuLPdUttLVbjTSDUg24nbgK9rqBKkrxVCH/E=";
  };

  build-system = [ setuptools ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flake8_class_newline" ];

  meta = with lib; {
    description = "Flake8 extension to check if a new line is present after a class definition";
    homepage = "https://github.com/alexandervaneck/flake8-class-newline";
    license = licenses.mit;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
