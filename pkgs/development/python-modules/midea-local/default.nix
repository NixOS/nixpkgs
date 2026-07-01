{
  lib,
  aiofiles,
  aiohttp,
  buildPythonPackage,
  colorlog,
  commonregex,
  defusedxml,
  deprecated,
  fetchFromGitHub,
  ifaddr,
  platformdirs,
  pycryptodome,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "midea-local";
  version = "6.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "midea-lan";
    repo = "midea-local";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FOhz/3YvaqtfWfkhhW8moHkbdeLmk8dv32SPAJ4KblY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    colorlog
    commonregex
    defusedxml
    deprecated
    ifaddr
    pycryptodome
    platformdirs
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    typing-extensions
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
