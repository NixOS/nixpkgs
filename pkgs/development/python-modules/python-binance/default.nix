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
  version = "1.0.10";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sammchardy";
    repo = pname;
    rev = "v${version}";
    sha256 = "09pq2blvky1ah4k8yc6zkp2g5nkn3awc52ad3lxvj6m33akfzxiv";
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

  pythonImportsCheck = [ "binance" ];

  meta = with lib; {
    description = "Binance Exchange API python implementation for automated trading";
    homepage = "https://github.com/sammchardy/python-binance";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
