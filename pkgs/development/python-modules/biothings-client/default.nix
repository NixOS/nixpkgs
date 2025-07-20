{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  pytestCheckHook,
  pytest-asyncio,
}:
buildPythonPackage rec {
  pname = "biothings-client";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biothings";
    repo = "biothings_client.py";
    tag = "v${version}";
    hash = "sha256-uItIVoWbclF5Xkt7BxI/Q9sfKtrOJxYeJJmTd2NeGfo=";
  };

  build-system = [ setuptools ];
  dependencies = [ httpx ];
  pythonImportsCheck = [ "biothings_client" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  enabledTestPaths = [
    # All other tests make network requests to exercise the API
    "tests/test_async.py::test_generate_async_settings"
    "tests/test_async.py::test_url_protocol"
    "tests/test_async.py::test_async_client_proxy_discovery"
    "tests/test_async_variant.py::test_format_hgvs"
    "tests/test_sync.py::test_generate_settings"
    "tests/test_sync.py::test_url_protocol"
    "tests/test_sync.py::test_client_proxy_discovery"
    "tests/test_variant.py::test_format_hgvs"
  ];

  meta = {
    changelog = "https://github.com/biothings/biothings_client.py/blob/${src.tag}/CHANGES.txt";
    description = "Wrapper to access Biothings.api-based backend services";
    homepage = "https://github.com/biothings/biothings_client.py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rayhem ];
  };
}
