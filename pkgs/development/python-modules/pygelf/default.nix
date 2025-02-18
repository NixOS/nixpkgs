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
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pygelf";
    inherit version;
    hash = "sha256-0LuPRf9kipoYdxP0oFwJ9oX8uK3XsEu3Rx8gBxvRGq0=";
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
    maintainers = with lib.maintainers; [ drupol ];
  };
}
