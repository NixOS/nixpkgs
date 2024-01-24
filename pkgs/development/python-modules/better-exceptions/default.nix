{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage {
  pname = "better-exceptions";
  version = "0.3.3-unstable-2023-01-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qix-";
    repo = "better-exceptions";
    rev = "f7f1476e57129dc74d241b4377b0df39c37bc8a7";
    hash = "sha256-c8m4VLD+PDayzhdIURXUHVwf4HrfjXYNUjftThGzm9g=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # ValueError: Cause error
    "test/test_chaining.py"
    # TypeError: unsupported operand type(s) for +: 'int' and 'str'
    "test/test_encoding.py"
    # IndentationError: unexpected indent
    "test/test_indentation_error.py"
    # SyntaxError: invalid syntax
    "test/test_syntax_error.py"
    # TypeError: unsupported operand type(s) for +: 'int' and 'str'
    "test/test_truncating.py"
    # TypeError: unsupported operand type(s) for +: 'int' and 'str'
    "test/test_truncating_disabled.py"
  ];

  disabledTests = [
    # TypeError: unsupported operand type(s) for +: 'int' and 'str'
    "test_add"
  ];

  # Some check files need to be disabled because of various errors, same with some tests.
  # After disabling and running the build, no tests are collected
  doCheck = false;

  pythonImportsCheck = [
    "better_exceptions"
  ];

  meta = {
    description = "Pretty and useful exceptions in Python, automatically";
    homepage = "https://github.com/Qix-/better-exceptions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
