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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5MCsXCkYnoLEZZoj9WrO/Z3VzTKagoOrMCuTpA4dGAQ=";
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
