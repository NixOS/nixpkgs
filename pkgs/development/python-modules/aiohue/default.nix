{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, asyncio-throttle
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/NcCo4Jvq1JeXD1UTrzNpPNDNmEt7GOrbCl79V00+eM=";
  };

  propagatedBuildInputs = [
    aiohttp
    asyncio-throttle
  ];

  pythonImportsCheck = [
    "aiohue"
    "aiohue.discovery"
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Python package to talk to Philips Hue";
    homepage = "https://github.com/home-assistant-libs/aiohue";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
