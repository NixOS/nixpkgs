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
  version = "0.6.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "PennyDreadfulMTG";
    repo = "pystache";
    tag = "v${version}";
    hash = "sha256-E6y7r68mfXVoNgsTBqyo561dVOjq1fL73SqSFM32oeQ=";
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
    homepage = "https://github.com/defunkt/pystache";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nickcao ];
  };
}
