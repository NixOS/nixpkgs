{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # dependencies
  fastapi,
  pydantic,
  pyyaml,
  aiohttp,
  slowapi,

  # check inputs
  pytestCheckHook,
  httpx,
  httpx2,
  playwright,
  pytest-cov,
  pytest-asyncio,
  pytest-xdist,
  pytest-timeout,
  typer,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "proxmox-sdk";
  version = "0.0.15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emersonfelipesp";
    repo = "proxmox-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-scOYPIrini8Aa2q+ncQl/uuv0Pn0QMq7brwXfkz9v5M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastapi
    pydantic
    pyyaml
    aiohttp
    slowapi
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpx
    httpx2
    playwright
    pytest-cov
    pytest-asyncio
    pytest-xdist
    pytest-timeout
    typer
    uvicorn
  ];

  disabledTests = [
    # requires internet
    "test_public_checksum_probe_refuses_internal_redirect"
  ];

  disabledTestPaths = [
    #requires playwright browsers.json
    "tests/test_codegen_crawler_security.py"
  ];

  pythonImportsCheck = [ "proxmox_sdk" ];

  meta = {
    description = "Proxmox Async SDK";
    homepage = "https://github.com/emersonfelipesp/proxmox-sdk";
    changelog = "https://github.com/emersonfelipesp/proxmox-sdk/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
