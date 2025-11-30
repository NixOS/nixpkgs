{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pegen";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "we-like-parsers";
    repo = "pegen";
    tag = "v${version}";
    hash = "sha256-P4zX8za9lBlXhNPkQe9p136ggZEJh6fHfBr+DQKvtTg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pegen" ];

  disabledTests = [
    # ValueError: Expected locations of (1, 3) and...
    "test_invalid_call_arguments"
  ]
  ++ lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/we-like-parsers/pegen/issues/89
    "test_invalid_def_stmt"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.13") [
    "tests/python_parser/test_ast_parsing.py"
    "tests/python_parser/test_syntax_error_handling.py"
    "tests/python_parser/test_unsupported_syntax.py"
  ];

  meta = with lib; {
    description = "Library to generate PEG parsers";
    homepage = "https://github.com/we-like-parsers/pegen";
    changelog = "https://github.com/we-like-parsers/pegen/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
