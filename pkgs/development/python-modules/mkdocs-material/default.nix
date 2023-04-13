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
  version = "9.0.15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-GIzHgCU4BzHuQMBleGn9DcJBm+pQ7/JP67e8eIcyhpc=";
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
