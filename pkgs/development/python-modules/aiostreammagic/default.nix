{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiostreammagic";
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "noahhusby";
    repo = "aiostreammagic";
    rev = "refs/tags/${version}";
    hash = "sha256-CFd8/nyE3hLbmzO/MJEnllIe2MvfD/jkGIpNdYxI8N0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiostreammagic" ];

  meta = {
    description = "Module for interfacing with Cambridge Audio/Stream Magic compatible streamers";
    homepage = "https://github.com/noahhusby/aiostreammagic";
    changelog = "https://github.com/noahhusby/aiostreammagic/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
