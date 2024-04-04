{
  lib,
  stdenv,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  importlib-metadata,
  mock,
  pydantic,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "rstcheck-core";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = "rstcheck-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-PiQMk0lIv24S6qXMYIQR+SkSji+WA30ivWs2uPQwf2A=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-strict-prototypes";
  };

  dependencies =
    [
      docutils
      pydantic
    ]
    ++ lib.optionals (pythonOlder "3.9") [
      importlib-metadata
      typing-extensions
    ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/rstcheck/rstcheck-core/issues/84
    "test_check_yaml_returns_error_on_bad_code_block"
  ];

  pythonImportsCheck = [ "rstcheck_core" ];

  meta = with lib; {
    description = "Library for checking syntax of reStructuredText";
    homepage = "https://github.com/rstcheck/rstcheck-core";
    changelog = "https://github.com/rstcheck/rstcheck-core/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
