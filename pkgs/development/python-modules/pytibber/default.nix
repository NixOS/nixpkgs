{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, async-timeout
, graphql-subscription-manager
, python-dateutil
, pytz
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytibber";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyTibber";
    rev = version;
    sha256 = "sha256-lUe79VHlK/2/1SZfC+Ha+27NUoIKoTlqn75XA/mPCNU=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    graphql-subscription-manager
    python-dateutil
    pytz
  ];

  checkInputs = [
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
