{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pep440";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Python module to check whether versions number match PEP 440";
    mainProgram = "pep440";
    homepage = "https://github.com/Carreau/pep440";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
