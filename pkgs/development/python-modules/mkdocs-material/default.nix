{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, colorama
, hatch-requirements-txt
, hatch-nodejs-version
, hatchling
, jinja2
, markdown
, mkdocs
, mkdocs-material-extensions
, pygments
, pymdown-extensions
, pythonOlder
, regex
, requests
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "9.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2Z1U71agXxkYp1OFYd/xInAfN5SVI9FQf39b8DkX10o=";
  };

  nativeBuildInputs = [
    hatch-requirements-txt
    hatch-nodejs-version
    hatchling
  ];

  propagatedBuildInputs = [
    colorama
    jinja2
    markdown
    mkdocs
    mkdocs-material-extensions
    pygments
    pymdown-extensions
    regex
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
