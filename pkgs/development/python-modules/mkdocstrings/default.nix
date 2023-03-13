{ lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, markdown
, markupsafe
, mkdocs
, mkdocs-autorefs
, pymdown-extensions
, pytestCheckHook
, pdm-pep517
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocstrings";
  version = "0.20.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-eFHcwbYEIwVWvDJWlmeUvEdqp3NYAF8SgdHJGw6bEMc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"' \
      --replace 'license = "ISC"' 'license = {text = "ISC"}'
  '';

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    jinja2
    markdown
    markupsafe
    mkdocs
    mkdocs-autorefs
    pymdown-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mkdocstrings"
  ];

  disabledTestPaths = [
    # Circular dependencies
    "tests/test_extension.py"
  ];

  disabledTests = [
    # Not all requirements are available
    "test_disabling_plugin"
  ];

  meta = with lib; {
    description = "Automatic documentation from sources for MkDocs";
    homepage = "https://github.com/mkdocstrings/mkdocstrings";
    changelog = "https://github.com/mkdocstrings/mkdocstrings/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
