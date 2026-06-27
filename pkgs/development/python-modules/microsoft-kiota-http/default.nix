{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
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

buildPythonPackage (finalAttrs: {
  pname = "microsoft-kiota-http";
  version = "1.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-http-v${finalAttrs.version}";
    hash = "sha256-hhYQsNcy+jVVmKiDuB1nGpx+aA7toM6WDFoU5Vnu5Vs=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/http/httpx/";

  build-system = [ flit-core ];

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
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
