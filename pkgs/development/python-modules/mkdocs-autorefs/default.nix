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
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "autorefs";
    rev = version;
    hash = "sha256-kiHb/XSFw6yaUbLJHBvHaQAOVUM6UfyFeomgniDZqgU=";
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
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
