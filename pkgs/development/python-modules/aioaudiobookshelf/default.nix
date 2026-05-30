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
  version = "0.1.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "aioaudiobookshelf";
    tag = version;
    hash = "sha256-MEkIcPtNNHvWUBLGRhJGbMnS5cMclGqINuLqvGK8Ivg=";
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
