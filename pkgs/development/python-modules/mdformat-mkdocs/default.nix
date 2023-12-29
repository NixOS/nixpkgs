{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mdformat
, mdformat-gfm
, mdit-py-plugins
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-mkdocs";
  version = "1.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-l4B/DR0pKZG62+sBG+fiux/XeF3ewxb2TYa+Zs1O3kU=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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
