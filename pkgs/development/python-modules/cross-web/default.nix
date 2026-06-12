{
  lib,
  aiohttp,
  buildPythonPackage,
  chalice,
  django,
  fastapi,
  fetchFromGitHub,
  flask,
  hatchling,
  httpx,
  litestar,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  python-multipart,
  quart,
  sanic-testing,
  sanic,
  starlette,
  typing-extensions,
  werkzeug,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "cross-web";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usecross";
    repo = "cross-web";
    rev = finalAttrs.version;
    hash = "sha256-JxwzTU17jCQMFNCtmcZVAZQnwDZjHNxCGNdKhkCMoPs=";
  };

  build-system = [ hatchling ];

  dependencies = [ typing-extensions ];

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
    pytest-django
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "cross_web" ];

  preCheck = ''
    export PYTHONPATH="$PYTHONPATH:$PWD/tests"
  '';

  env.DJANGO_SETTINGS_MODULE = "testing._django_settings";

  meta = {
    description = "Universal web framework adapter for Python";
    homepage = "https://github.com/usecross/cross-web";
    changelog = "https://github.com/usecross/cross-web/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
