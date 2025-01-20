{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyasyncore,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyasynchat";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "pyasynchat";
    rev = "v${version}";
    hash = "sha256-Cep8tsapLjhPbVhMrC1ZUgd4jZZLOliL4yF0OX2KrYs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyasyncore
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "asynchat"
  ];

  meta = {
    description = "Make asynchat available for Python 3.12 onwards";
    homepage = "https://github.com/simonrob/pyasynchat";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ ];
  };
}
