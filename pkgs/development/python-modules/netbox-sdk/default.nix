{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # dependencies
  fastapi,
  aiohttp,
  pydantic,
  email-validator,
  jsonschema,
  rich,
  pyyaml,

  # check inputs
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-sdk";
  version = "0.0.13";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emersonfelipesp";
    repo = "netbox-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ufV6mLqZEFp+SyebnceP3C2jTwsbnWRlXbhsitKGAgM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
    email-validator
    jsonschema
    rich
    pyyaml
  ];

  pythonRelaxDeps = [ "pydantic" ];

  # TODO
  # ERROR: usage: python -m pytest [options] [file_or_dir] [file_or_dir] [...]
  # python -m pytest: error: unrecognized arguments: -n
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "netbox_sdk" ];

  meta = {
    description = "Modern NetBox toolkit with an SDK, CLI and TUI for faster automation";
    homepage = "https://github.com/emersonfelipesp/netbox-sdk";
    changelog = "https://github.com/emersonfelipesp/netbox-sdk/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
