{
  lib,
  authlib,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  httpx-sse,
  httpx,
  mashumaro,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-httpx,
  pytestCheckHook,
  setuptools,
  typer,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohomeconnect";
  version = "0.36.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiohomeconnect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tm8CEIv2QfawDs26oCnwXZ4cX/9785h7IX/kuCzjCWc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    httpx-sse
    mashumaro
  ];

  optional-dependencies = {
    cli = [
      authlib
      fastapi
      typer
      uvicorn
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-httpx
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "aiohomeconnect" ];

  meta = {
    description = "asyncio client for the Home Connect API";
    homepage = "https://github.com/MartinHjelmare/aiohomeconnect";
    changelog = "https://github.com/MartinHjelmare/aiohomeconnect/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
