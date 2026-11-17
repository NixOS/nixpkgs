{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  aiohttp,
  pytak,
  aircot,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "adsbcot";
  version = "9.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snstac";
    repo = "adsbcot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kRmkjrGhQaP3goFZoLdWm5RKrQEMeNPCqr1oLVTBgQw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pytak
    aircot
    websockets
  ];

  pythonRelaxDeps = [ "websockets" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "adsbcot" ];

  meta = {
    description = "Display Aircraft in TAK - ADS-B to TAK Gateway";
    homepage = "https://adsbcot.readthedocs.io";
    changelog = "https://github.com/snstac/adsbcot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
