{
  lib,
  aiohttp,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  fetchpatch,
  pycryptodome,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  six,
  ujson,
  websockets,
}:

buildPythonPackage rec {
  pname = "python-binance";
  version = "1.0.17";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sammchardy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-e88INUEkjOSVOD0KSs9LmstuQ7dQZdJk8K6VqFEusww=";
  };

  patches = [
    (fetchpatch {
      name = "fix-unable-to-determine-version-error.patch";
      url = "https://github.com/sammchardy/python-binance/commit/1b9dd4853cafccf6cdacc13bb64a18632a79a6f1.patch";
      hash = "sha256-6KRHm2cZRcdD6qMdRAwlea4qLZ1/1YFzZAQ7Ph4XMCs=";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    dateparser
    requests
    pycryptodome
    six
    ujson
    websockets
  ];

  nativeCheckInputs = [
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
