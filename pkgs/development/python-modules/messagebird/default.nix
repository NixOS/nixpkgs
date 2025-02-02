{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pyjwt,
  mock,
  python-dateutil,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "messagebird";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "messagebird";
    repo = "python-rest-api";
    rev = version;
    hash = "sha256-2KVAxdHT5+Ie3ZRxXZhU0hLOtHWjIiJi+ferkYTlSn0=";
  };

  propagatedBuildInputs = [
    pyjwt
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "messagebird" ];

  disabledTestPaths = [
    # ValueError: not enough values to unpack (expected 6, got 0)
    "tests/test_request_validator.py"
  ];

  meta = with lib; {
    description = "Client for MessageBird's REST API";
    homepage = "https://github.com/messagebird/python-rest-api";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
