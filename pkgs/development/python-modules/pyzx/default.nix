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
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zxcalc";
    repo = "pyzx";
    tag = "v${version}";
    hash = "sha256-MhsbJIDeSIeF0LaHhI6nNxPD3ZjBWh5yvLGuwBH41a4=";
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

  pythonRelaxDeps = [
    "ipywidgets"
    "lark"
  ];

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
    changelog = "https://github.com/zxcalc/pyzx/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
