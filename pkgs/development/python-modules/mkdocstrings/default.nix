{ lib
, buildPythonApplication
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

buildPythonApplication rec {
  pname = "mkdocstrings";
  version = "0.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = version;
    sha256 = "sha256-7OF1CrRnE4MYHuYD/pasnZpLe9lrbieGp4agnWAaKVo=";
  };

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

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  pythonImportsCheck = [
    "mkdocstrings"
  ];

  disabledTestPaths = [
    # Circular dependencies
    "tests/test_extension.py"
  ];

  meta = with lib; {
    description = "Automatic documentation from sources for MkDocs";
    homepage = "https://github.com/mkdocstrings/mkdocstrings";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
