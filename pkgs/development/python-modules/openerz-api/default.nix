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
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "misialq";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3I4IuVx4e8ReGm1nCjNEv8mNOqytdiWjNMJm8VXVfYI=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [
    "openerz_api"
  ];

  meta = with lib; {
    description = "Python module to interact with the OpenERZ API";
    homepage = "https://github.com/misialq/openerz-api";
    changelog = "https://github.com/misialq/openerz-api/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
