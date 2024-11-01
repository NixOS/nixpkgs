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
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "autorefs";
    rev = "refs/tags/${version}";
    hash = "sha256-C1ca7tx9s88U7Xp/bd3KhlWeb32a612RyCVBQz0vJ1g=";
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
    changelog = "https://github.com/mkdocstrings/autorefs/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
