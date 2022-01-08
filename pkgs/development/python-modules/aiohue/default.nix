{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, asyncio-throttle
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "3.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-McC5DX3Cti9eGpPniywNY2DvbAqHSFwhek85TJN/zn0=";
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
