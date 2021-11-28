{ lib
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymelcloud";
  version = "2.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vilppuvuorinen";
    repo = pname;
    rev = "v${version}";
    sha256 = "2bq/kCSCKUnm8QvEEbnWU85/xwgyLN0eG0v788EKzKk=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pymelcloud"
  ];

  meta = with lib; {
    description = "Python module for interacting with MELCloud";
    homepage = "https://github.com/vilppuvuorinen/pymelcloud";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
