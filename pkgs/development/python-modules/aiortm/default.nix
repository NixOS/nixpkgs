{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  sybil,
  typer,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiortm";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiortm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WtcpODzewytX5AyF3YbFyCqe6EWc0UJUvB90FU3MYCo=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    ciso8601
    mashumaro
    yarl
  ];

  optional-dependencies = {
    cli = [ typer ];
  };

  nativeCheckInputs = [
    aioresponses
    aiointercept
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    sybil
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "aiortm" ];

  meta = {
    description = "Library for the Remember the Milk API";
    homepage = "https://github.com/MartinHjelmare/aiortm";
    changelog = "https://github.com/MartinHjelmare/aiortm/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "aiortm";
  };
})
