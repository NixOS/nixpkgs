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
  version = "0.1.60";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RwwZDb4mQJZw8w1sTFJ0eM3az4pDQbVLGtA+anyKEJM=";
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
