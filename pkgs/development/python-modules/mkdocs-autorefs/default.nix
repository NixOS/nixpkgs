{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  markdown,
  mkdocs-material,
  pytestCheckHook,
  pdm-backend,
  markupsafe,
}:

buildPythonPackage rec {
  pname = "mkdocs-autorefs";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "autorefs";
    tag = version;
    hash = "sha256-/UPhoJL026jpdvC22uRFiAGN4pU/uqcDrROZmkTFWv0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ pdm-backend ];

  dependencies = [
    markdown
    markupsafe
    mkdocs-material
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Circular dependencies
    "tests/test_api.py"
  ];

  disabledTests = [
    # missing pymdownx
    "test_reference_implicit_with_code_inlinehilite_plain"
    "test_reference_implicit_with_code_inlinehilite_python"
  ];

  pythonImportsCheck = [ "mkdocs_autorefs" ];

  meta = {
    description = "Automatically link across pages in MkDocs";
    homepage = "https://github.com/mkdocstrings/autorefs/";
    changelog = "https://github.com/mkdocstrings/autorefs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
}
