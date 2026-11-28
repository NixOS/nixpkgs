{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hassette-wire,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "hassette-client";
  version = "0.64.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NodeJSmith";
    repo = "hassette";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EbodQdt9yZZ7HTlnxFbw/Aa+SZ7f6322CSKEKOmyqxQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/client";

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    hassette-wire
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hassette_client" ];

  meta = {
    description = "Client for the hassette web API";
    homepage = "https://github.com/NodeJSmith/hassette";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
