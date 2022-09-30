{ lib
, buildPythonPackage
, fetchFromGitHub
, lark
, pydot
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "amarna";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "amarna";
    rev = "v${version}";
    hash = "sha256-cE7OhACLpRmbJWzMsGTidbbw9FOKBbz47LEJwTW6wck=";
  };

  propagatedBuildInputs = [
    lark
    pydot
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "amarna"
  ];

  meta = with lib; {
    description = "Static-analyzer and linter for the Cairo programming language";
    homepage = "https://github.com/crytic/amarna";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
