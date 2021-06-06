{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.23";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "newville";
    repo = pname;
    rev = version;
    sha256 = "sha256-9Zxb2EzB6nxDQHdlryFiwyNW+76VvysLUB78bXKzfv0=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asteval" ];

  meta = with lib; {
    description = "AST evaluator of Python expression using ast module";
    homepage = "https://github.com/newville/asteval";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
