{ lib
, paho-mqtt
, buildPythonPackage
, fetchPypi
, aiohttp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyeconet";
  version = "0.1.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zxD2sjKWB/bmxwpVFgkKTngMhr4bVuW+qkSt+pbxqPY=";
  };

  propagatedBuildInputs = [
    paho-mqtt
    aiohttp
  ];

  # Tests require credentials
  doCheck = false;

  pythonImportsCheck = [
    "pyeconet"
  ];

  meta = with lib; {
    description = "Python interface to the EcoNet API";
    homepage = "https://github.com/w1ll1am23/pyeconet";
    changelog = "https://github.com/w1ll1am23/pyeconet/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
