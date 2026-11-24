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
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "midea-local";
  version = "15.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "midea-lan";
    repo = "midea-local";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rgryUG5uvmGw5j0fZY0dr+4jHLj2qDAbj8CkI+FA7OM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.2.1" "setuptools"
  '';

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

  pythonRelaxDeps = [
    "pycryptodome"
    "platformdirs"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
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
