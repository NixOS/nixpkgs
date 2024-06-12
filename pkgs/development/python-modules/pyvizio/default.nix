{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchPypi,
  jsonpickle,
  requests,
  tabulate,
  xmltodict,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pyvizio";
  version = "0.1.61";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AtqMWe2zgRqOp5S9oKq7keHNHM8pnTmV1mfGiVzygTc=";
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
    mainProgram = "pyvizio";
    homepage = "https://github.com/vkorn/pyvizio";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
