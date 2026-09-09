{
  lib,
  stdenv,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  mock,
  pydantic,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "rstcheck-core";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = "rstcheck-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tz6saJfGlP6h21Jckyw4LBgcRALwFvlV+z+cAis2j5s=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-strict-prototypes";

  dependencies = [
    docutils
    pydantic
  ];

  nativeCheckInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # severity was bumped from severe/4 to error/3
    "test_include_directive_error_without_sphinx"
  ];

  pythonImportsCheck = [ "rstcheck_core" ];

  meta = {
    description = "Library for checking syntax of reStructuredText";
    homepage = "https://github.com/rstcheck/rstcheck-core";
    changelog = "https://github.com/rstcheck/rstcheck-core/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
