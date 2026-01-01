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
<<<<<<< HEAD
  version = "2.6.0";
=======
  version = "2.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-mystrom";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-EXYBrOgpbOSGsNGqNKHBPam0/Gn050q+CjyAN7KJ7O8=";
=======
    hash = "sha256-G3LbaEF7e61woa1Y3J1OmR0krIfjk2t6nX13lil+4G0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python API client for interacting with myStrom devices";
    longDescription = ''
      Asynchronous Python API client for interacting with myStrom devices.
      There is support for bulbs, motion sensors, plugs and buttons.
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-mystrom";
    changelog = "https://github.com/home-assistant-ecosystem/python-mystrom/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mystrom";
  };
}
