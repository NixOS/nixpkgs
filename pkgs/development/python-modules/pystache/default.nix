{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  setuptools-scm,
  importlib-metadata,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pystache";
  version = "0.6.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "PennyDreadfulMTG";
    repo = "pystache";
    tag = "v${version}";
    hash = "sha256-UVmDpg7wCPnY+1BZqujIYdgt/AT4gZ+RTYdD+ORQhzE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pystache" ];

  meta = {
    description = "Framework-agnostic, logic-free templating system inspired by ctemplate and et";
    homepage = "https://github.com/PennyDreadfulMTG/pystache";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nickcao ];
  };
}
