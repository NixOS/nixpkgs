{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, pandas
, pytestCheckHook
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "alpha-vantage";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "RomelTorres";
    repo = "alpha_vantage";
    rev = version;
    sha256 = "0cyw6zw7c7r076rmhnmg905ihwb9r7g511n6gdlph06v74pdls8d";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    requests-mock
    pandas
    pytestCheckHook
  ];

  # @asyncio.coroutine decorator is removed since Python 3.11 so asyncio module doesn't have @asyncio.coroutine decorator
  # you need to use async keyword before def which requires an update upstream
  # upstream is pending a new release with fixed patches
  doCheck = false;

  disabledTestPaths = [
    # Tests require network access
    "test_alpha_vantage/test_integration_alphavantage.py"
    "test_alpha_vantage/test_integration_alphavantage_async.py"
  ];

  pythonImportsCheck = [ "alpha_vantage" ];

  meta = with lib; {
    description = "Python module for the Alpha Vantage API";
    homepage = "https://github.com/RomelTorres/alpha_vantage";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
