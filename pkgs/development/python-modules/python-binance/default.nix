{ lib
, aiohttp
, buildPythonPackage
, dateparser
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, six
, ujson
, websockets
}:

buildPythonPackage rec {
  pname = "python-binance";
  version = "1.0.16";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sammchardy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2v3qeykjQR/CUOC6F0Xomm49Q+wrYJS8vmL3+u6ew0M=";
  };

  propagatedBuildInputs = [
    aiohttp
    dateparser
    requests
    six
    ujson
    websockets
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_api_request.py"
    "tests/test_historical_klines.py"
  ];

  pythonImportsCheck = [
    "binance"
  ];

  meta = with lib; {
    description = "Binance Exchange API python implementation for automated trading";
    homepage = "https://github.com/sammchardy/python-binance";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
