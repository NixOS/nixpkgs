{ lib
, buildPythonPackage
, fetchPypi
, pytest-localserver
, pytestCheckHook
, pythonOlder
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7GdeCA0Gv40fteWmih5c0N9GsJx4IwMV9lCvXkA2vsc=";
  };

  propagatedBuildInputs = [
    requests
    six
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
