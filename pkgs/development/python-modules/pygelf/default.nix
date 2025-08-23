{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mock,
  pytestCheckHook,
  requests,
}:
buildPythonPackage rec {
  pname = "pygelf";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    pname = "pygelf";
    inherit version;
    hash = "sha256-jtlyVjvjyPFoSD8B2/UitrxpeVnJej9IgTJLP3ljiRE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pygelf" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    requests
  ];

  disabledTests = [
    # ConnectionRefusedError: [Errno 111] Connection refused
    "test_static_fields"
    "test_dynamic_fields"
  ];

  disabledTestPaths = [
    # These tests requires files that are stripped off by Pypi packaging
    "tests/test_queuehandler_support.py"
    "tests/test_debug_mode.py"
    "tests/test_common_fields.py"
  ];

  meta = {
    description = "Python logging handlers with GELF (Graylog Extended Log Format) support";
    homepage = "https://github.com/keeprocking/pygelf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
