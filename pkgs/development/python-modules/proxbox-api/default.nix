{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # dependencies
  fastapi,
  proxmox-sdk,
  netbox-sdk,
  sqlmodel,
  pydantic,
  httpx,
  httpcore,
  aiosqlite,
  cryptography,
  bcrypt,
  asyncssh,
  websockets,

  # check inputs
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "proxbox-api";
  version = "0.0.23.post2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emersonfelipesp";
    repo = "proxbox-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QY+gUrg7s2SArJUom2QTvCc8zG0nWD8YNKE7g+ETZBo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastapi
    proxmox-sdk
    netbox-sdk
    sqlmodel
    pydantic
    httpx
    httpcore
    aiosqlite
    cryptography
    bcrypt
    asyncssh
    websockets
  ];

  # TODO
  # ERROR: usage: python -m pytest [options] [file_or_dir] [file_or_dir] [...]
  # python -m pytest: error: unrecognized arguments: -n
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "proxbox_api" ];

  meta = {
    description = "Backend of NetBox Proxbox Plugin using FastAPI";
    homepage = "https://github.com/emersonfelipesp/proxbox-api";
    changelog = "https://github.com/emersonfelipesp/proxbox-api/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
