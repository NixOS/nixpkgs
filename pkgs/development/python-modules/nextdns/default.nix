{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
  tenacity,
}:

buildPythonPackage rec {
  pname = "nextdns";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "nextdns";
    rev = "refs/tags/${version}";
    hash = "sha256-2BT47Dg+1TLDUccdb0Q/r3QzpRURTwFlUORbQpmIJzc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    tenacity
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # mocked object called too many times
    "test_retry_error"
    "test_retry_success"
  ];

  pythonImportsCheck = [ "nextdns" ];

  meta = with lib; {
    description = "Module for the NextDNS API";
    homepage = "https://github.com/bieniu/nextdns";
    changelog = "https://github.com/bieniu/nextdns/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
