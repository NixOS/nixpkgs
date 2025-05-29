{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "aiokem";
  version = "0.5.11";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "kohlerlibs";
    repo = "aiokem";
    tag = "v${version}";
    hash = "sha256-1fBGmsp6DoDP1EUjp2tfWT3nTux0/2iiC6x/LxrCrd8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyjwt
  ];

  pythonImportsCheck = [ "aiokem" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/kohlerlibs/aiokem/blob/${src.tag}/CHANGELOG.md";
    description = "Async API for Kohler Energy Management";
    homepage = "https://github.com/kohlerlibs/aiokem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
