{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, click
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "python-mystrom";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kqv5rUdwkynOzssID77gVYyzs0CDR/bUWh6zpt5zOP8=";
  };

  propagatedBuildInputs = [
    aiohttp
    click
    requests
    setuptools
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [
    "pymystrom.bulb"
    "pymystrom.pir"
    "pymystrom.switch"
  ];

  meta = with lib; {
    description = "Python API client for interacting with myStrom devices";
    longDescription = ''
      Asynchronous Python API client for interacting with myStrom devices.
      There is support for bulbs, motion sensors, plugs and buttons.
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-mystrom";
    changelog = "https://github.com/home-assistant-ecosystem/python-mystrom/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
