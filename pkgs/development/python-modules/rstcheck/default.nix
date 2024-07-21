{
  lib,
  stdenv,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  rstcheck-core,
  typer,
  types-docutils,
}:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "6.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = "rstcheck";
    rev = "refs/tags/v${version}";
    hash = "sha256-S04l+x/rIc/XSvq2lSKCQp6KK5mmKI2mOgPgJ3WKe5M=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    docutils
    rstcheck-core
    types-docutils
    pydantic
    typer
  ] ++ typer.optional-dependencies.all;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # Disabled until https://github.com/rstcheck/rstcheck-core/issues/19 is resolved.
    "test_error_without_config_file_macos"
    "test_file_1_is_bad_without_config_macos"
  ];

  pythonImportsCheck = [ "rstcheck" ];

  preCheck = ''
    # The tests need to find and call the rstcheck executable
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "Checks syntax of reStructuredText and code blocks nested within it";
    homepage = "https://github.com/myint/rstcheck";
    changelog = "https://github.com/rstcheck/rstcheck/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ staccato ];
    mainProgram = "rstcheck";
  };
}
