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
, trove-classifiers
, pythonOlder
, regex
, requests
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "9.4.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-oP0DeSRgoLx6boEOa3if5BitGXmJ11DoUVZK16Sjlwg=";
  };

  nativeBuildInputs = [
    hatch-requirements-txt
    hatch-nodejs-version
    hatchling
    trove-classifiers
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
    changelog = "https://github.com/squidfunk/mkdocs-material/blob/${src.rev}/CHANGELOG";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion caarlos0 ];
  };
}
