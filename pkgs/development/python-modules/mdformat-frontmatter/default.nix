{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, linkify-it-py
, markdown-it-py
, mdformat
, mdit-py-plugins
, ruamel-yaml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-frontmatter";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "butler54";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-PhT5whtvvcYSs5gHQEsIvV1evhx7jR+3DWFMHrF0uMw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  buildInputs = [
    mdformat
    mdit-py-plugins
  ];

  propagatedBuildInputs = [
    ruamel-yaml
  ];

  pythonImportsCheck = [
    "mdformat_frontmatter"
  ];

  meta = with lib; {
    description = "mdformat plugin to ensure frontmatter is respected";
    homepage = "https://github.com/butler54/mdformat-frontmatter";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero polarmutex ];
  };
}
