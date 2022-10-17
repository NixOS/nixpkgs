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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "050dkx29wrmdd8z7pmyk36k2ihpapqi4qmyb70bm6xl5l4jh4k7j";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
