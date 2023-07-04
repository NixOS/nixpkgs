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
  version = "1.0.2";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-H+wqgcXNrdrZ5aQvZ7XM8YpBpVZM6pFtsANC00UZ0jM=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
