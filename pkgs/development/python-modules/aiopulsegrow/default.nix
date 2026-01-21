{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopulsegrow";
  version = "25.12.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "aiopulsegrow";
    tag = finalAttrs.version;
    hash = "sha256-Srtk8EmvTQvx2//TuB2JR74lw58EdLORKWDnvTPStww=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
    pytest-aiohttp
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "aiopulsegrow" ];

  meta = {
    description = "Python async api client for Pulse Grow";
    homepage = "https://github.com/pvizeli/aiopulsegrow";
    changelog = "https://github.com/pvizeli/aiopulsegrow/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
