{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.21";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "newville";
    repo = pname;
    rev = version;
    sha256 = "1bhdj7zybsqghgd7qx50il7nwfg79qx9wg03n0z96jgq5gydqd9w";
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
