{ lib
, buildPythonPackage
, fetchPypi
, pytest-localserver
, pytestCheckHook
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OAytTBwdyULl6KjqrgtNTt9wj08BDbi3vPr60fzSVP8=";
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
