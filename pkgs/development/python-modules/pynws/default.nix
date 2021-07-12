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
  version = "1.3.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MatthewFlamm";
    repo = pname;
    rev = "v${version}";
    sha256 = "13ipmx60kicwh8qxjazap4vk94x8i3r0lnkdsap7gffaizwgp49d";
  };

  propagatedBuildInputs = [
    aiohttp
    metar
  ];

  checkInputs = [
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
