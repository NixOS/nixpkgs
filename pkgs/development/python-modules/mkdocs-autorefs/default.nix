{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown
, mkdocs
, pytestCheckHook
, pdm-backend
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocs-autorefs";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "autorefs";
    rev = "refs/tags/${version}";
    hash = "sha256-YORrIQ+iZQZ1U/fe/IH3B/5gN0QxQF73s9vF6qvKL7Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    markdown
    mkdocs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # missing pymdownx
    "test_reference_implicit_with_code_inlinehilite_plain"
    "test_reference_implicit_with_code_inlinehilite_python"
  ];

  pythonImportsCheck = [
    "mkdocs_autorefs"
  ];

  meta = with lib; {
    description = "Automatically link across pages in MkDocs";
    homepage = "https://github.com/mkdocstrings/autorefs/";
    changelog = "https://github.com/mkdocstrings/autorefs/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
