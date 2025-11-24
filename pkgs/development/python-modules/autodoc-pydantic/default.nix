{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build-system
  poetry-core,

  # dependencies
  importlib-metadata,
  pydantic,
  pydantic-settings,
  sphinx,

  # tests
  pytestCheckHook,
}:

let
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "mansenfranzen";
    repo = "autodoc_pydantic";
    tag = "v${version}";
    hash = "sha256-Rm3r4skW6YaeU7v9LATR+jRQcFdri/x+lpOm7BYV2a4=";
  };
in
buildPythonPackage {
  pname = "autodoc-pydantic";
  inherit version src;
  pyproject = true;

  build-system = [ poetry-core ];

  dependencies = [
    importlib-metadata
    pydantic
    pydantic-settings
    sphinx
  ];

  pythonImportsCheck = [ "sphinxcontrib.autodoc_pydantic" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # AttributeError: 'NoneType' object has no attribute 'env'
    "test_add_fallback_css_class_false"
    "test_add_fallback_css_class_true"

    # AssertionError: assert ['', '.. py:p..._conint', ...] == ['', '.. py:p..._c...
    "test_autodoc_pydantic_field_show_constraints_various"
  ];

  meta = {
    changelog = "https://github.com/mansenfranzen/autodoc_pydantic/blob/${src.tag}/CHANGELOG.md";
    description = "Seamlessly integrate pydantic models in your Sphinx documentation";
    downloadPage = "https://github.com/mansenfranzen/autodoc_pydantic/releases/tag/${src.tag}";
    homepage = "https://autodoc-pydantic.readthedocs.io/en/${src.tag}";
    license = lib.licenses.mit;
    teams = with lib.teams; [ deshaw ];
  };
}
