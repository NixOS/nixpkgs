{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiotankerkoenig";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "aiotankerkoenig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0s0wapqMb0R/0aa7jlJLHgs7cXhLrqUjMiwZj2kUGEw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aiotankerkoenig" ];

  meta = {
    description = "Python module for interacting with tankerkoenig.de";
    homepage = "https://github.com/jpbede/aiotankerkoenig";
    changelog = "https://github.com/jpbede/aiotankerkoenig/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
