{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gatus-api";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TN-1";
    repo = "gatus-api";
    tag = "V${finalAttrs.version}";
    hash = "sha256-BJ5Kzfo7REmADEkgnWrhbqObR6hyLr/fBiz18A81V+k=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gatus_api" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Asynchronous Python client for the Gatus API";
    homepage = "https://github.com/TN-1/gatus-api";
    changelog = "https://github.com/TN-1/gatus-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
