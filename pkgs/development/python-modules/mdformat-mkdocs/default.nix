{ lib
, buildPythonPackage
, fetchFromGitHub
, mdformat
, mdformat-gfm
, mdit-py-plugins
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-mkdocs";
  version = "1.0.4";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mGWeG8clWJ7obsvO+gYaVzfAyDOh9HNdyWW5KgOgfmM=";
  };

  buildInputs = [
    mdformat
    mdformat-gfm
    mdit-py-plugins
  ];

  pythonImportsCheck = [
    "mdformat_mkdocs"
  ];

  meta = with lib; {
    description = "mdformat plugin for MkDocs";
    homepage = "https://github.com/KyleKing/mdformat-mkdocs";
changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
