{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  anyio,
  httpx,
  pytest-asyncio,
  pytest-vcr,
}:

buildPythonPackage rec {
  pname = "notion-client";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ramnes";
    repo = "notion-sdk-py";
    tag = version;
    hash = "sha256-oqYBT7K0px0QvShSx1fnr2181h+QXz7I8sdURsBRgWw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ httpx ];

  # disable coverage options as they don't provide us value, and they break the default pytestCheckHook
  preCheck = ''
    sed -i '/addopts/d' ./setup.cfg
  '';

  nativeCheckInputs = [
    pytestCheckHook
    anyio
    pytest-asyncio
    pytest-vcr
  ];

  pythonImportsCheck = [ "notion_client" ];

  disabledTests = [
    # requires network access
    "test_api_http_response_error"
  ];

  meta = with lib; {
    description = "Python client for the official Notion API";
    homepage = "https://github.com/ramnes/notion-sdk-py";
    changelog = "https://github.com/ramnes/notion-sdk-py/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
