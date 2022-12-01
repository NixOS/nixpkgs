{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-localserver
, pytestCheckHook
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = pname;
    rev = version;
    hash = "sha256-qYohrXrQkUBPo7yC+ZOwidDaCg/2nteXKAOCUvR4k2Q=";
  };

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  checkInputs = [
    pytest-localserver
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "responses"
  ];

  meta = with lib; {
    description = "Python module for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
