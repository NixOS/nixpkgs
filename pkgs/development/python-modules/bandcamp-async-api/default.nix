{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  python-dotenv,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "bandcamp-async-api";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ALERTua";
    repo = "bandcamp_async_api";
    tag = finalAttrs.version;
    hash = "sha256-JXW0pnIYIy+TmhmgRAk/arWC3RMTV23n1DTOwqyDPmY=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "bandcamp_async_api" ];

  nativeCheckInputs = [
    pytest-asyncio
    python-dotenv
    pytestCheckHook
  ];

  meta = {
    description = "Modern, asynchronous Python client for the Bandcamp API";
    homepage = "https://github.com/ALERTua/bandcamp_async_api";
    # https://github.com/ALERTua/bandcamp_async_api/issues/34
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
