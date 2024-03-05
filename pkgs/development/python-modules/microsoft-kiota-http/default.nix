{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, httpx
, microsoft-kiota-abstractions
, opentelemetry-api
, opentelemetry-sdk
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, urllib3
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-http";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-http-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-N3+oAH3yWgrl0v2fm4xdCxzj7u/0fbQI3xHFht39vzA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    httpx
    microsoft-kiota-abstractions
    opentelemetry-api
    opentelemetry-sdk
  ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    urllib3
  ];

  pythonImportsCheck = [
    "kiota_http"
  ];

  meta = with lib; {
    description = "HTTP request adapter implementation for Kiota clients for Python";
    homepage = "https://github.com/microsoft/kiota-http-python";
    changelog = "https://github.com/microsoft/kiota-http-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
