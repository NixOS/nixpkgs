{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "can-isotp";
  version = "2.0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pylessard";
    repo = "python-can-isotp";
    rev = "refs/tags/v${version}";
    hash = "sha256-wfZMVfLBdYkFbb0DiDWmGaraykJ/QL64Zkl2/nBu4lY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # we don't support socket tests
    "test/test_can_stack.py"
    "test/test_layer_vs_socket.py"
    "test/test_socket.py"

    # behaves inconsistently due to timing
    "test/test_transport_layer.py"
    "test/test_helper_classes.py"
  ];

  pythonImportsCheck = [ "isotp" ];

  meta = with lib; {
    description = "Python package that provides support for ISO-TP (ISO-15765) protocol";
    homepage = "https://github.com/pylessard/python-can-isotp";
    changelog = "https://github.com/pylessard/python-can-isotp/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      jacobkoziej
    ];
  };
}
