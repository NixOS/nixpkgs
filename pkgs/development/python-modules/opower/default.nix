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

buildPythonPackage rec {
  pname = "opower";
  version = "0.15.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "opower";
    tag = "v${version}";
    hash = "sha256-jSokUs3aJJmcsTPkt2OEkCATLekuOVDGBufi8Fb2rtg=";
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

  meta = with lib; {
    description = "Module for getting historical and forecasted usage/cost from utilities that use opower.com";
    homepage = "https://github.com/tronikos/opower";
    changelog = "https://github.com/tronikos/opower/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
