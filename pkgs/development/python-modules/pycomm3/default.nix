{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycomm3";
  version = "1.2.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ottowayi";
    repo = "pycomm3";
    rev = "refs/tags/v${version}";
    hash = "sha256-KdvmISMH2HHU8N665QevVw7q9Qs5CwjXxcWpLoziY/Y=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycomm3" ];

  disabledTestPaths = [
    # Don't test examples as some have aditional requirements
    "examples/"
    # No physical PLC available
    "tests/online/"
  ];

  meta = with lib; {
    description = "A Python Ethernet/IP library for communicating with Allen-Bradley PLCs";
    homepage = "https://github.com/ottowayi/pycomm3";
    changelog = "https://github.com/ottowayi/pycomm3/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
