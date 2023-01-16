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
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "misialq";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6q0mKWyTTlNJ/DCeAsck1meM5dQovYBcV2EqmjlABvc=";
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

  disabledTests = [
    # Assertion issue
    "test_sensor_make_api_request"
  ];

  meta = with lib; {
    description = "Python module to interact with the OpenERZ API";
    homepage = "https://github.com/misialq/openerz-api";
    changelog = "https://github.com/misialq/openerz-api/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
