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
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VFsTA/isBw0H7qXQhOX6K2p1QcVxO7q5TIzf8YivVgc=";
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
