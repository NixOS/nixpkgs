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
  pythonOlder,
  urllib3,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-http";
  version = "1.9.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-text-v${version}";
    hash = "sha256-59vuJc7Wb/6PsPA4taAFA2UK8bdz+raZ+NB4S8LahtM=";
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

  meta = with lib; {
    description = "HTTP request adapter implementation for Kiota clients for Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/http/httpx";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-http-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
