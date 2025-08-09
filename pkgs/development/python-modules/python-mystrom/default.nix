{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "python-mystrom";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-mystrom";
    tag = version;
    hash = "sha256-zG1T+wC0GznNwP3fi8GKtY9Csq9hyX0vw+h7ARVPQFQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    click
    requests
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
    changelog = "https://github.com/home-assistant-ecosystem/python-mystrom/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "mystrom";
  };
}
