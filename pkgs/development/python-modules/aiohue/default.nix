{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, asyncio-throttle
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wPqEubd+vUpdj7tM0CTPkW5kV4qlF19T+djlGrtA5h8=";
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
