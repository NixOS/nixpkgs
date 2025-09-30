{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest7CheckHook,
  setuptools,
  coverage,
  six,
}:

buildPythonPackage rec {
  pname = "doubles";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uber";
    repo = "doubles";
    tag = "v${version}";
    hash = "sha256-7yygZ00H2eIGuI/E0dh0j30hicJKBhCqyagY6XAJTCA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    coverage
    six
  ];

  nativeCheckInputs = [
    pytest7CheckHook
  ];

  # To avoid a ValueError: Plugin already registered under a different name:
  # doubles.pytest_plugin
  pytestFlags = [
    "-p"
    "no:doubles"
  ];

  disabledTestPaths = [
    # nose is deprecated
    "test/nose_test.py"

    # These tests fail due to an incompatibility between the doubles pytest plugin
    # and modern pytest versions (7+). The plugin's verification hook incorrectly
    # raises a generic `AssertionError` during teardown, instead of the specific
    # exceptions the negative test cases are designed to catch.
    "test/allow_test.py"
    "test/expect_test.py"
    "test/class_double_test.py"
    "test/object_double_test.py"
  ];

  pythonImportsCheck = [ "doubles" ];

  meta = {
    description = "Test doubles for Python";
    homepage = "https://github.com/uber/doubles";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
