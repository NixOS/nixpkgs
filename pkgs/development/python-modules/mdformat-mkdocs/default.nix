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
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-mkdocs";
    rev = "refs/tags/v${version}";
    hash = "sha256-GUSoGx4cwhjQO4AiC9s0YIcK3N/Gr+PrYR3+B8G9CoQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  buildInputs = [
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
    description = "mdformat plugin for MkDocs";
    homepage = "https://github.com/KyleKing/mdformat-mkdocs";
    changelog = "https://github.com/KyleKing/mdformat-mkdocs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
