{ lib
, paho-mqtt
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "pyeconet";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pxwsmxzbmrab6p6qr867pc43ky2yjv2snra534wrdrknpj40h4s";
  };

  propagatedBuildInputs = [
    paho-mqtt
    aiohttp
  ];

  # Tests require credentials
  doCheck = false;
  pythonImportsCheck = [ "pyeconet" ];

  meta = with lib; {
    description = "Python interface to the EcoNet API";
    homepage = "https://github.com/w1ll1am23/pyeconet";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
