{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  click,
  cryptography,
  dateparser,
  fetchFromGitHub,
  marshmallow-dataclass,
  poetry-core,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
  tabulate,
  typeguard,
}:

buildPythonPackage (finalAttrs: {
  pname = "renault-api";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "renault-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L5Ld6CyMapW2qX5YmExQzfWddQkQjSHgy7sz3OtL4TQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    cryptography
    marshmallow-dataclass
    pyjwt
  ];

  optional-dependencies = {
    cli = [
      click
      dateparser
      tabulate
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
    typeguard
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "renault_api" ];

  meta = {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    changelog = "https://github.com/hacf-fr/renault-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "renault-api";
  };
})
