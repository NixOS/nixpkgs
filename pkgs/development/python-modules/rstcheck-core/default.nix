{ stdenv
, lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, importlib-metadata
, mock
, poetry-core
, pydantic
, pytest-mock
, pytestCheckHook
, pythonOlder
, types-docutils
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rstcheck-core";
  version = "1.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9U+GhkwBr+f3yEe7McOxqPRUuTp9vP+3WT5wZ92n32w=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    docutils
    importlib-metadata
    pydantic
    types-docutils
    typing-extensions
  ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Disabled until https://github.com/rstcheck/rstcheck-core/issues/19 is resolved.
    "test_error_without_config_file_macos"
    "test_file_1_is_bad_without_config_macos"
  ];

  pythonImportsCheck = [
    "rstcheck_core"
  ];

  meta = with lib; {
    description = "Library for checking syntax of reStructuredText";
    homepage = "https://github.com/rstcheck/rstcheck-core";
    changelog = "https://github.com/rstcheck/rstcheck-core/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
