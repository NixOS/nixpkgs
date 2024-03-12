{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, freezegun
, metar
, pytest-aiohttp
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynws";
  version = "1.6.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MatthewFlamm";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-x56kfnmdVV0Fc7XSI60rrtEl4k3uzpIdZxTofUbkUHU=";
  };

  propagatedBuildInputs = [
    aiohttp
    metar
  ];

  nativeCheckInputs = [
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pynws" ];

  meta = with lib; {
    description = "Python library to retrieve data from NWS/NOAA";
    homepage = "https://github.com/MatthewFlamm/pynws";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
