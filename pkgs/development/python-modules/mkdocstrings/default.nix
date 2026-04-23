{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  markdown,
  markupsafe,
  mkdocs,
  mkdocs-autorefs,
  pdm-backend,
  pymdown-extensions,
  pytestCheckHook,
  dirty-equals,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocstrings";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "mkdocstrings";
    tag = finalAttrs.version;
    hash = "sha256-uiw2jNdzmq0kM6GxAzJs8TMTBjuk25kvuIMXxIa28VQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ pdm-backend ];

  dependencies = [
    jinja2
    markdown
    markupsafe
    mkdocs
    mkdocs-autorefs
    pymdown-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    dirty-equals
  ];

  pythonImportsCheck = [ "mkdocstrings" ];

  disabledTestPaths = [
    # Circular dependencies
    "tests/test_api.py"
    "tests/test_extension.py"
  ];

  disabledTests = [
    # Not all requirements are available
    "test_disabling_plugin"
    # Circular dependency on mkdocstrings-python
    "test_extended_templates"
    "test_nested_autodoc[ext_markdown0]"
  ];

  meta = {
    description = "Automatic documentation from sources for MkDocs";
    homepage = "https://github.com/mkdocstrings/mkdocstrings";
    changelog = "https://github.com/mkdocstrings/mkdocstrings/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
})
