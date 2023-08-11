{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown
, mkdocs
, pytestCheckHook
, pdm-pep517
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocs-autorefs";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "autorefs";
    rev = "refs/tags/${version}";
    hash = "sha256-GZKQlOXhQIQhS/z4cbmS6fhAKYgnVhSXh5a8Od7+TWc=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    markdown
    mkdocs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

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
