{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  mashumaro,
  python-socketio,
}:

buildPythonPackage rec {
  pname = "aioaudiobookshelf";
  version = "0.1.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "aioaudiobookshelf";
    tag = version;
    hash = "sha256-i5S9rrC4Ap4RG7PEfqCiS3wNw7drlI0cvbWwm8Lx1hA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    mashumaro
    python-socketio
  ];

  pythonImportsCheck = [
    "aioaudiobookshelf"
  ];

  meta = {
    description = "Async python library to interact with Audiobookshelf";
    homepage = "https://github.com/music-assistant/aioaudiobookshelf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
