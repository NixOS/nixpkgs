{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  cbor2,
  pycryptodomex,
  busypie,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-vcr,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "freenub";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "freenub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2yUuopr7sT2FvsiXlHnc7AnXcCAAEAyD0Rpc4j/nGmQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    cbor2
    pycryptodomex
    requests
  ];

  pythonRelaxDeps = [ "cbor2" ];

  nativeCheckInputs = [
    busypie
    pytest-asyncio
    pytest-cov-stub
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pubnub" ];

  meta = {
    description = "Fork of pubnub";
    homepage = "https://github.com/bdraco/freenub";
    changelog = "https://github.com/bdraco/freenub/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
