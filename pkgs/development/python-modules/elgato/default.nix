{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  syrupy,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "elgato";
  version = "6.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-elgato";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dnbz3ssvxX2nR17W0UP2zW6rebbinr5JeI2tfwjl6o4=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    cryptography
    mashumaro
    orjson
    yarl
  ];

  optional-dependencies.cli = [
    rich
    typer
    zeroconf
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  pythonImportsCheck = [ "elgato" ];

  meta = {
    description = "Python client for Elgato Key Lights";
    homepage = "https://github.com/frenck/python-elgato";
    changelog = "https://github.com/frenck/python-elgato/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
