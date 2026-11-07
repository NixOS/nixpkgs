{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  orjson,
  quantile-python,
  aiohttp,
  aiohttp-basicauth,
  starlette,
  quart,
  pytestCheckHook,
  httpx,
  fastapi,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioprometheus";
  version = "22.5.0-unstable-2023-12-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "claws";
    repo = "aioprometheus";
    rev = "2fabe659c3c5259b50ac90c3106df7d41b8a3c74";
    hash = "sha256-GD4vJ+1P3TBg3rBvlMArRBOWRIzT/y+2cHfkPRLkjdQ=";
  };

  build-system = [ setuptools ];
  dependencies = [
    orjson
    quantile-python
  ];

  nativeCheckInputs = [
    pytestCheckHook
    aiohttp-basicauth
    httpx
    fastapi
    uvicorn
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "aioprometheus" ];

  __darwinAllowLocalNetworking = true;

  passthru.optional-dependencies = {
    aiohttp = [ aiohttp ];
    starlette = [ starlette ];
    quart = [ quart ];
  };

  meta = {
    description = "Prometheus Python client library for asyncio-based applications";
    homepage = "https://github.com/claws/aioprometheus";
    changelog = "https://github.com/claws/aioprometheus/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
