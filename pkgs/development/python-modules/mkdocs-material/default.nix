{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, hatchling
, hatch-nodejs-version
, hatch-requirements-txt
, jinja2
, markdown
, mkdocs
, mkdocs-material-extensions
, pygments
, pymdown-extensions
, pythonOlder
, requests
}:

let
  pname = "mkdocs-material";
  version = "8.5.10";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";
  # format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2F82yHUBeFNibViWrqkirMaaE24p87Sf2AFRC/41R1s=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-nodejs-version
    hatch-requirements-txt
  ];

  propagatedBuildInputs = [
    jinja2
    markdown
    mkdocs
    mkdocs-material-extensions
    pygments
    pymdown-extensions
    requests
  ];

  # No tests for python
  doCheck = false;

  pythonImportsCheck = [
    "mkdocs"
  ];

  meta = with lib; {
    description = "Material for mkdocs";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
