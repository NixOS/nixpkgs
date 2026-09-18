{
  lib,
  aiohttp,
  aiointercept,
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
  syrupy_6,
  tabulate,
  typeguard,
}:

buildPythonPackage (finalAttrs: {
  pname = "renault-api";
  version = "0.5.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "renault-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+kzIPnz34uTjUQ9hksxr3RIEg0+/w+8BdoH+ruenzi0=";
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
    aiointercept
    pytest-asyncio
    pytestCheckHook
    syrupy_6
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
