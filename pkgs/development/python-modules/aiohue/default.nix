{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xinllv2cvxl9fxi15nayzw9lfzijb3m7i49gkkr46qr8xvsavyk";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [
    "aiohue"
    "aiohue.discovery"
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "asyncio package to talk to Philips Hue";
    homepage = "https://github.com/balloob/aiohue";
    license = licenses.asl20;
  };
}
