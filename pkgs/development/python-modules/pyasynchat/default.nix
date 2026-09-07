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
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonrob";
    repo = "pyasynchat";
    rev = "v${version}";
    hash = "sha256-KJmUou1llxUhDrMCOpJxqYNnPpJ0OoQv5VwYs/PJXbs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyasyncore
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = null;

  pythonImportsCheck = [
    "asynchat"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Make asynchat available for Python 3.12 onwards";
    homepage = "https://github.com/simonrob/pyasynchat";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
}
