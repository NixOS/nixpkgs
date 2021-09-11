{ lib
, buildPythonPackage
, cookies
, fetchPypi
, mock
, pytest-localserver
, pytestCheckHook
, pythonOlder
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k/d0p2LuDifA2dfgYieu2p/59faTkvcrtsa3P4djVj4=";
  };

  propagatedBuildInputs = [
    requests
    urllib3
    six
  ] ++ lib.optionals (pythonOlder "3.4") [
    cookies
  ] ++ lib.optionals (pythonOlder "3.3") [
    mock
  ];

  checkInputs = [
    pytest-localserver
    pytestCheckHook
  ];

  pythonImportsCheck = [ "responses" ];

  meta = with lib; {
    description = "Python module for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
