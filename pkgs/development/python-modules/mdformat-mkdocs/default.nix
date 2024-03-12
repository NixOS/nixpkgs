{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mdformat
, mdformat-gfm
, mdit-py-plugins
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mdformat-mkdocs";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-mkdocs";
    rev = "refs/tags/v${version}";
    hash = "sha256-cqzsrEsYFX9HnC6fRKqefysT0ZSgAllTJEXleOdepXc=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mdformat
    mdformat-gfm
    mdit-py-plugins
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mdformat_mkdocs"
  ];

  meta = with lib; {
    description = "Mdformat plugin for MkDocs";
    homepage = "https://github.com/KyleKing/mdformat-mkdocs";
    changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
