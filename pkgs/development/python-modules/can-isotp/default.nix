{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "can-isotp";
  version = "2.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylessard";
    repo = "python-can-isotp";
    tag = "v${version}";
    hash = "sha256-Gts6eeeto++DKnkojFvCwyPVPRSq2OcTA0jAYrPAWJI=";
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

  meta = {
    description = "Python package that provides support for ISO-TP (ISO-15765) protocol";
    homepage = "https://github.com/pylessard/python-can-isotp";
    changelog = "https://github.com/pylessard/python-can-isotp/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jacobkoziej
    ];
  };
}
