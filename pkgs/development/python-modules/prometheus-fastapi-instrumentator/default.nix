{
  lib,
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
  version = "7.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "trallnag";
    repo = "prometheus-fastapi-instrumentator";
    tag = "v${version}";
    hash = "sha256-ObzaKWrN+9+MUpSOlqbW16KKTklMVo5nPRHodk+GEPs=";
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
    platforms = lib.platforms.linux; # numerous test failures on Darwin
  };
}
