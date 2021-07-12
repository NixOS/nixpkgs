{ lib
, aiohttp
, buildPythonPackage
, click
, fetchPypi
, jsonpickle
, requests
, tabulate
, xmltodict
, zeroconf
}:

buildPythonPackage rec {
  pname = "pyvizio";
  version = "0.1.59";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j2zbziklx4az55m3997y7yp4xflk7i0gsbdfh7fp9k0qngb2053";
  };

  propagatedBuildInputs = [
    aiohttp
    click
    jsonpickle
    requests
    tabulate
    xmltodict
    zeroconf
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyvizio" ];

  meta = with lib; {
    description = "Python client for Vizio SmartCast";
    homepage = "https://github.com/vkorn/pyvizio";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
