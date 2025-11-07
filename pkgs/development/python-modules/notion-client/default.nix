{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-vcr,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "notion-client";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ramnes";
    repo = "notion-sdk-py";
    tag = version;
    hash = "sha256-kUeZhnQwZ+To5NCo7jtQsTfX1kQotbAHDcHf2qwGOIs=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    anyio
    pytest-asyncio
    pytest-cov-stub
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "notion_client" ];

  disabledTests = [
    # Test requires network access
    "test_api_http_response_error"
  ];

  meta = with lib; {
    description = "Python client for the official Notion API";
    homepage = "https://github.com/ramnes/notion-sdk-py";
    changelog = "https://github.com/ramnes/notion-sdk-py/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
