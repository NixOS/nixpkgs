{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  asyncio-throttle,
}:

buildPythonPackage rec {
  pname = "deezer-python-async";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "deezer-python-async";
    tag = "v${version}";
    hash = "sha256-uuAB+SC/ECG50ox/6Bi+94bAt+YZokeQChpDQUAK+zc=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    aiohttp
    asyncio-throttle
  ];

  doCheck = false; # requires access to the deezer api

  pythonImportsCheck = [
    "deezer"
  ];

  meta = {
    description = "Deezer client for python *but async";
    homepage = "https://github.com/music-assistant/deezer-python-async";
    changelog = "https://github.com/music-assistant/deezer-python-async/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
