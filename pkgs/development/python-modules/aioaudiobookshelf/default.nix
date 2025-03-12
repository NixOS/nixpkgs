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
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "aioaudiobookshelf";
    tag = version;
    hash = "sha256-rUd8TwmQDeMxXu7/UBnN426N+BMas2u6RNpTBXa3/5g=";
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
