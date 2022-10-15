{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, async-timeout
, graphql-subscription-manager
, python-dateutil
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytibber";
  version = "0.25.3";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    rev = "refs/tags/${version}";
    hash = "sha256-QpKPGAksaKfdLpiBn4fbVxTsoBUd8S6loSKF+EE443g=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    graphql-subscription-manager
    python-dateutil
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test/test.py"
  ];

  # tests access network
  doCheck = false;

  pythonImportsCheck = [
    "tibber"
  ];

  meta = with lib; {
    description = "Python library to communicate with Tibber";
    homepage = "https://github.com/Danielhiversen/pyTibber";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
