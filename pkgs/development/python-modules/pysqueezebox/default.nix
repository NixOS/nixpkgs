{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rajlaud";
    repo = "pysqueezebox";
    tag = "v${version}";
    hash = "sha256-1kkvqmmO197IjIcUlnmnKoeOq+0njbrgwogDU+ivIqw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pysqueezebox" ];

  disabledTests = [
    # Test contacts 192.168.1.1
    "test_bad_response"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_integration.py"
  ];

  meta = {
    description = "Asynchronous library to control Logitech Media Server";
    homepage = "https://github.com/rajlaud/pysqueezebox";
    changelog = "https://github.com/rajlaud/pysqueezebox/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
