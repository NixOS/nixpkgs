{
  lib,
  aiohttp,
  aiozoneinfo,
  arrow,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyotp,
  pytest-asyncio,
  python-dotenv,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "opower";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "opower";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A3x16hYZ0UHikPTsADC9JZ22ZfaIrgCgUOP8PTnaQHI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiozoneinfo
    arrow
    cryptography
    pyotp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    python-dotenv
  ];

  disabledTestPaths = [
    # network access
    "tests/test_opower.py"
  ];

  pythonImportsCheck = [ "opower" ];

  disabledTests = [
    # Tests require network access
    "test_invalid_auth"
  ];

  meta = {
    description = "Module for getting historical and forecasted usage/cost from utilities that use opower.com";
    homepage = "https://github.com/tronikos/opower";
    changelog = "https://github.com/tronikos/opower/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
