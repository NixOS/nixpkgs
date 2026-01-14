{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycomm3";
  version = "1.2.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ottowayi";
    repo = "pycomm3";
    tag = "v${version}";
    hash = "sha256-xcN0TKwWg23CDBmwMRZlPFuKYpeLg7KSXzhRtNuP6Ls=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycomm3" ];

  disabledTestPaths = [
    # Don't test examples as some have additional requirements
    "examples/"
    # No physical PLC available
    "tests/online/"
  ];

  meta = {
    description = "Python Ethernet/IP library for communicating with Allen-Bradley PLCs";
    homepage = "https://github.com/ottowayi/pycomm3";
    changelog = "https://github.com/ottowayi/pycomm3/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
