{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  starlette,
  sentry-sdk,
  pytestCheckHook,
  pytest-mock,
  pytest-asyncio,
  fastapi,
  httpx,
  requests,
  websockets,
}:
buildPythonPackage (finalAttrs: {
  pname = "asgi-correlation-id";
  version = "5.0.1";
  pyproject = true;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "snok";
    repo = "asgi-correlation-id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KLoc+MGgw+gcN5UfGXt2UMTK488voCsqxlhtVBG+kjM=";
  };
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.7.2,<0.8' 'uv_build'
  '';

  build-system = [ uv-build ];

  dependencies = [ starlette ];

  optional-dependencies = {
    sentry = [ sentry-sdk ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-asyncio
    fastapi
    httpx
    requests
    websockets
  ]
  ++ finalAttrs.passthru.optional-dependencies.sentry;

  pythonImportsCheck = [ "asgi_correlation_id" ];
  meta = {
    description = "Middleware correlating project logs to individual requests";
    homepage = "https://github.com/snok/asgi-correlation-id";
    changelog = "https://github.com/snok/asgi-correlation-id/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
