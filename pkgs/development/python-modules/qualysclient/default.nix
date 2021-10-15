{ lib
, buildPythonPackage
, certifi
, charset-normalizer
, fetchFromGitHub
, idna
, lxml
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, responses
, urllib3
}:

buildPythonPackage rec {
  pname = "qualysclient";
  version = "0.0.4.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "woodtechie1428";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fdcmspjm1cy53x9gm7frfq175saskcwn565zqprgxzfcigip1n3";
  };

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    idna
    lxml
    requests
    urllib3
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "qualysclient"
  ];

  meta = with lib; {
    description = "Python SDK for interacting with the Qualys API";
    homepage = "https://qualysclient.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
