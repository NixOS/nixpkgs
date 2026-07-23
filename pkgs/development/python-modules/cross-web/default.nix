{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  typing-extensions,

  # optional-dependencies
  fastapi,
  httpx,
  python-multipart,
  starlette,
  django,
  flask,
  werkzeug,
  sanic,
  aiohttp,
  yarl,
  quart,
  chalice,
  litestar,
  sanic-testing,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cross-web";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usecross";
    repo = "cross-web";
    rev = finalAttrs.version;
    hash = "sha256-CH7SKePJcBgLPrdb3/qoim0Wzdx78+rNpJFWDHO7JWA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  optional-dependencies = {
    integrations = [
      fastapi
      httpx
      python-multipart
      starlette
      django
      flask
      werkzeug
      sanic
      aiohttp
      yarl
      quart
      chalice
      litestar
      sanic-testing
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [
    "cross_web"
  ];

  meta = {
    description = "Universal web framework adapter for Python";
    homepage = "https://github.com/usecross/cross-web";
    changelog = "https://github.com/usecross/cross-web/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
