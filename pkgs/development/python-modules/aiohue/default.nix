{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, asyncio-throttle
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "3.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LwtE9F5ic0aZ9/q3dSWn20O27yW/QD/Yi1NPdFmiP10=";
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
