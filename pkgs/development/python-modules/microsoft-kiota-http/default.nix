{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx,
  microsoft-kiota-abstractions,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  urllib3,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-http";
  version = "1.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-http-v${version}";
    hash = "sha256-05/I06p3zBc/Kb7H8dMEbUxFr0dOXSSBuIyEGZ4twhA=";
  };

  sourceRoot = "${src.name}/packages/http/httpx/";

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    microsoft-kiota-abstractions
    opentelemetry-api
    opentelemetry-sdk
  ]
  ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    urllib3
  ];

  pythonImportsCheck = [ "kiota_http" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-http-v";
  };

  meta = {
    description = "HTTP request adapter implementation for Kiota clients for Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/http/httpx";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
