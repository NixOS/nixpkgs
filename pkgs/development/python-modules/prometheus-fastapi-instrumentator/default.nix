{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  devtools,
  fastapi,
  httpx,
  poetry-core,
  prometheus-client,
  requests,
  starlette,
}:

buildPythonPackage rec {
  pname = "prometheus-fastapi-instrumentator";
  version = "7.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "trallnag";
    repo = "prometheus-fastapi-instrumentator";
    tag = "v${version}";
    hash = "sha256-54h/kwIdzFzxdYglwcEBPkLYno1YH2iWklg35qY2b00=";
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
    httpx
    pytestCheckHook
    requests
  ];

  # numerous test failures on Darwin
  doCheck = stdenv.hostPlatform.isLinux;

  pythonImportsCheck = [ "prometheus_fastapi_instrumentator" ];

  meta = {
    description = "Instrument FastAPI with Prometheus metrics";
    homepage = "https://github.com/trallnag/prometheus-fastapi-instrumentator";
    changelog = "https://github.com/trallnag/prometheus-fastapi-instrumentator/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      isc
      bsd3
    ];
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
  };
}
