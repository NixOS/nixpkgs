{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiolichess";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aryanhasgithub";
    repo = "aiolichess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WCrvDNlq0i2FBD6Ouiue3BQcTuIV80Z8MT/5mOjTr3w=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  # upstream tests are empty
  doCheck = false;

  pythonImportsCheck = [ "aiolichess" ];

  meta = {
    description = "Async Python client for the Lichess REST API";
    homepage = "https://github.com/aryanhasgithub/aiolichess";
    changelog = "https://github.com/aryanhasgithub/aiolichess/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
