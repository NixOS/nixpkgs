{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
, wrapt
}:

buildPythonPackage rec {
  pname = "deprecat";
  version = "2.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjhajharia";
    repo = "deprecat";
    rev = "refs/tags/v${version}";
    hash = "sha256-uAabZAtZDhcX6TfiM0LnrAzxxS64ys+vdodmxO//0x8=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "deprecat"
  ];

  disabledTestPaths = [
    # https://github.com/mjhajharia/deprecat/issues/13
    "tests/test_sphinx.py"
  ];

  meta = with lib; {
    description = "Decorator to deprecate old python classes, functions or methods";
    homepage = "https://github.com/mjhajharia/deprecat";
    changelog = "https://github.com/mjhajharia/deprecat/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
