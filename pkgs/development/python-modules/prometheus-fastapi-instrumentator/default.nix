{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  prometheus-client,
  starlette,

  # tests
  devtools,
  fastapi,
  httpx2,
  pytest-asyncio,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "prometheus-fastapi-instrumentator";
  version = "8.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "trallnag";
    repo = "prometheus-fastapi-instrumentator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oSP0KH5niST0MICTxVyAdZmH08RTx3cgXQrOT83qBsM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    prometheus-client
    starlette
  ];

  nativeCheckInputs = [
    devtools
    fastapi
    httpx2
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  # numerous test failures on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  # TODO: Cleanup when https://github.com/NixOS/nixpkgs/pull/538958 reaches
  # `master`...
  disabledTests = lib.optionals (lib.versionOlder fastapi.version "0.137") [
    # Asserts that instrumentation works with fastapi 0.137+,
    # fails on nixpkgs with fastapi 0.136.
    "test_mount_inside_included_router_resolves_path"
  ];

  pythonImportsCheck = [ "prometheus_fastapi_instrumentator" ];

  meta = {
    description = "Instrument FastAPI with Prometheus metrics";
    homepage = "https://github.com/trallnag/prometheus-fastapi-instrumentator";
    changelog = "https://github.com/trallnag/prometheus-fastapi-instrumentator/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      isc
      bsd3
    ];
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
  };
})
