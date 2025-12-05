{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest7CheckHook,
  pythonOlder,
  setuptools,
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
    six
  ];

  nativeCheckInputs = [
    pytest7CheckHook
  ];

  preCheck = ''
    # imports coverage
    rm test/conftest.py
  '';

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

  disabledTests = lib.optionals (pythonOlder "3.13") [
    # doubles.exceptions.VerifyingDoubleArgumentError: class_method() missing 1 required positional argument: 'arg'
    "test_variable_that_points_to_class_method"
    # doubles.exceptions.VerifyingDoubleArgumentError: get_name() missing 1 required positional argument: 'self'
    "test_variable_that_points_to_instance_method"
  ];

  pythonImportsCheck = [ "doubles" ];

  meta = {
    description = "Test doubles for Python";
    homepage = "https://github.com/uber/doubles";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
