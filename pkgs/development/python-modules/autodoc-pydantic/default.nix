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

buildPythonPackage (finalAttrs: {
  pname = "autodoc-pydantic";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mansenfranzen";
    repo = "autodoc_pydantic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rm3r4skW6YaeU7v9LATR+jRQcFdri/x+lpOm7BYV2a4=";
  };

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
    changelog = "https://github.com/mansenfranzen/autodoc_pydantic/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Seamlessly integrate pydantic models in your Sphinx documentation";
    downloadPage = "https://github.com/mansenfranzen/autodoc_pydantic/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://autodoc-pydantic.readthedocs.io/en/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
