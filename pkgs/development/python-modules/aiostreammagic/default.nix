{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiostreammagic";
  version = "2.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "noahhusby";
    repo = "aiostreammagic";
    tag = finalAttrs.version;
    hash = "sha256-9HDQdzPq2YyVZ0GHmtJcK5ppk3OPNevYtlPK26hJ0TI=";
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
    changelog = "https://github.com/noahhusby/aiostreammagic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
