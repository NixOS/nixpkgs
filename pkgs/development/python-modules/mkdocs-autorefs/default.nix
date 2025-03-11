{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  markdown,
  mkdocs,
  pytestCheckHook,
  pdm-backend,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocs-autorefs";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "autorefs";
    tag = version;
    hash = "sha256-YVkj4D7JK0GOqnGlg5L3uqFsBB5C0OnlXX+wYW4GpkQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ pdm-backend ];

  dependencies = [
    markdown
    mkdocs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # missing pymdownx
    "test_reference_implicit_with_code_inlinehilite_plain"
    "test_reference_implicit_with_code_inlinehilite_python"
  ];

  pythonImportsCheck = [ "mkdocs_autorefs" ];

  meta = with lib; {
    description = "Automatically link across pages in MkDocs";
    homepage = "https://github.com/mkdocstrings/autorefs/";
    changelog = "https://github.com/mkdocstrings/autorefs/blob/${src.tag}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
