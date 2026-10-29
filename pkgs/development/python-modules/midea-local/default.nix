{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiofiles,
  aiohttp,
  anyio,
  colorlog,
  defusedxml,
  ifaddr,
  pycryptodome,
  platformdirs,
  typing-extensions,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "midea-local";
  version = "12.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "midea-lan";
    repo = "midea-local";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zaEVje2/whWj8PtKNO1WnpKkTdfwG+wor2raNrlAc4w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    anyio
    colorlog
    defusedxml
    ifaddr
    pycryptodome
    platformdirs
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "midealocal" ];

  meta = {
    description = "Control your Midea M-Smart appliances via local area network";
    homepage = "https://github.com/midea-lan/midea-local";
    changelog = "https://github.com/midea-lan/midea-local/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ k900 ];
    license = lib.licenses.mit;
  };
})
