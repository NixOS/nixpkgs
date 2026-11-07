{
  lib,
  aiohttp,
  aiosqlite,
  anyio,
  buildPythonPackage,
  croniter,
  cyclopts,
  deepdiff,
  fair-async-rlock,
  fastapi,
  fetchFromGitHub,
  frozendict,
  glom,
  hassette-client,
  hassette-wire,
  httpx2,
  humanize,
  jsonref,
  mergedeep,
  orjson,
  packaging,
  platformdirs,
  pydantic,
  pydantic-settings,
  python-dotenv,
  python-slugify,
  starlette,
  structlog,
  tenacity,
  tomli-w,
  typing-extensions,
  uv-build,
  uvicorn,
  uuid-utils,
  watchfiles,
  whenever,
}:

buildPythonPackage (finalAttrs: {
  pname = "hassette";
  version = "0.63.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NodeJSmith";
    repo = "hassette";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DO2Q9exyHaacd7InwDWKNk48qdvlFGUotDgD8peiDGY=";
  };

  build-system = [ uv-build ];

  # nixpkgs ships aiohttp 3.14.3, upstream requires >= 3.14.4.
  pythonRelaxDeps = [ "aiohttp" ];

  dependencies = [
    aiohttp
    aiosqlite
    anyio
    croniter
    cyclopts
    deepdiff
    fair-async-rlock
    fastapi
    frozendict
    glom
    hassette-client
    hassette-wire
    httpx2
    humanize
    jsonref
    mergedeep
    orjson
    packaging
    platformdirs
    pydantic
    pydantic-settings
    python-dotenv
    python-slugify
    starlette
    structlog
    tenacity
    tomli-w
    typing-extensions
    uuid-utils
    uvicorn
    watchfiles
    whenever
  ]
  ++ uvicorn.optional-dependencies.standard;

  # The suite needs uv, pyright, playwright and the repository's own codegen
  # package to run, so it is not run here.
  doCheck = false;

  pythonImportsCheck = [ "hassette" ];

  meta = {
    description = "Async framework for building Home Assistant automations";
    homepage = "https://github.com/NodeJSmith/hassette";
    license = lib.licenses.mit;
    mainProgram = "hassette";
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
