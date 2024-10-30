{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  ipywidgets,
  lark,
  numpy,
  pyperclip,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyzx";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zxcalc";
    repo = "pyzx";
    rev = "refs/tags/v${version}";
    hash = "sha256-4yc4P2v2L/F/A1A9z41ow2KA0aUA+3SJyC+wyMWzhwM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ipywidgets
    lark
    numpy
    pyperclip
    tqdm
    typing-extensions
  ];

  pythonRelaxDeps = [ "ipywidgets" ];

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    # too expensive, and print results instead of reporting failures:
    "tests/long_scalar_test.py"
    "tests/long_test.py"
  ];

  pythonImportsCheck = [
    "pyzx"
    "pyzx.circuit"
    "pyzx.graph"
    "pyzx.routing"
    "pyzx.local_search"
    "pyzx.scripts"
  ];

  meta = {
    description = "Library for quantum circuit rewriting and optimisation using the ZX-calculus";
    homepage = "https://github.com/zxcalc/pyzx";
    changelog = "https://github.com/zxcalc/pyzx/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
