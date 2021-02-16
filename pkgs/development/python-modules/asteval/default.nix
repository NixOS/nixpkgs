{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.22";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "newville";
    repo = pname;
    rev = version;
    sha256 = "sha256-93IBv6beYE/VTKJCWUbA1QTRdmQdn2kg35KBw6kmDis=";
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
