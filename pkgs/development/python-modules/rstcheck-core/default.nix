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
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "rstcheck-core";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = "rstcheck-core";
    tag = "v${version}";
    hash = "sha256-D17I6pncTnrRjA/vt4lt/Bfkko3Lx58Xyti3sM0sC3s=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-strict-prototypes";
  };

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
    # https://github.com/rstcheck/rstcheck-core/issues/84
    "test_check_yaml_returns_error_on_bad_code_block"
  ];

  pythonImportsCheck = [ "rstcheck_core" ];

  meta = with lib; {
    description = "Library for checking syntax of reStructuredText";
    homepage = "https://github.com/rstcheck/rstcheck-core";
    changelog = "https://github.com/rstcheck/rstcheck-core/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
