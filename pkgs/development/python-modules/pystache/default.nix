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
  version = "0.6.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "PennyDreadfulMTG";
    repo = "pystache";
    tag = "v${version}";
    hash = "sha256-kfR3ZXbrCDrIVOh4bcOTXqg9D56YQrIyV0NthStga5U=";
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
