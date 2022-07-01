{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, testfixtures
}:

buildPythonPackage rec {
  pname = "openerz-api";
  version = "0.1.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "misialq";
    repo = pname;
    rev = "v${version}";
    sha256 = "10kxsmaz2rn26jijaxmdmhx8vjdz8hrhlrvd39gc8yvqbjwhi3nw";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [ "openerz_api" ];

  meta = with lib; {
    description = "Python module to interact with the OpenERZ API";
    homepage = "https://github.com/misialq/openerz-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
