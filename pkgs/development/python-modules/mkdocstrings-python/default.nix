{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  griffe,
  inline-snapshot,
  mkdocs-autorefs,
  mkdocs-material,
  mkdocstrings,
  pdm-backend,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocstrings-python";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    tag = finalAttrs.version;
    hash = "sha256-MCR304sOqlS4azZOoNa4klITDdr+bD8N6wEZBuHhZms=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    griffe
    mkdocs-autorefs
    mkdocstrings
  ];

  nativeCheckInputs = [
    beautifulsoup4
    inline-snapshot
    mkdocs-material
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mkdocstrings_handlers" ];

  disabledTests = [
    # Tests fails with AssertionError
    "test_windows_root_conversion"
    # TypeError
    "test_format_code"
  ];

  meta = {
    description = "Python handler for mkdocstrings";
    homepage = "https://github.com/mkdocstrings/python";
    changelog = "https://github.com/mkdocstrings/python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
})
