{
  lib,
  aiohttp,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  pdm-backend,
  pytest-asyncio,
  pytestCheckHook,
  python-multipart,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohttp-asgi-connector";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thearchitector";
    repo = "aiohttp-asgi-connector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kvHsn8avq0Fi4ceg3ispFoQp0HJKzBv4tgley7XWMrY=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    fastapi
    pytest-asyncio
    pytestCheckHook
    python-multipart
  ];

  pythonImportsCheck = [ "aiohttp_asgi_connector" ];

  meta = {
    description = "An AIOHTTP ClientSession connector for directly interacting with ASGI applications";
    homepage = "https://github.com/thearchitector/aiohttp-asgi-connector";
    changelog = "https://github.com/thearchitector/aiohttp-asgi-connector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
