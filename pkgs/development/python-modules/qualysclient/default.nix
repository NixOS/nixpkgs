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
  version = "0.0.4.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "woodtechie1428";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hrbp5ci1l06j709k5y3z3ad9dryvrkvmc2wyb4a01gw7qzry7ys";
  };

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    idna
    lxml
    requests
    urllib3
  ];

  nativeCheckInputs = [
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
