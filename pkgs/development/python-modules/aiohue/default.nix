{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4933b8583d093da4c2772c40c59d262892539c7053996cea5b964a2cceaa386";
  };

  propagatedBuildInputs = [
    aiohttp
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
