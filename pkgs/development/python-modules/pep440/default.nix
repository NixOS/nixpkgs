{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pep440";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WLNyRswrE/7hyio8CSyzcE0h7PYhpb27Fo5E5pf20E0=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Don't run CLI tests
    "tests/test_cli.py"
  ];

  pythonImportsCheck = [ "pep440" ];

  meta = {
    description = "Python module to check whether versions number match PEP 440";
    mainProgram = "pep440";
    homepage = "https://github.com/Carreau/pep440";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
