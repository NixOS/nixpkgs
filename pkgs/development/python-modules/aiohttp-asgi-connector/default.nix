{
  lib,
  aiohttp,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-multipart,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiohttp-asgi-connector";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thearchitector";
    repo = "aiohttp-asgi-connector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tL17gBNYHnHKvG0nK4XmxBM9EjrmfpaNSkdZkLzjrCg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.18,<0.13.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    fastapi
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    python-multipart
  ];

  pythonImportsCheck = [ "aiohttp_asgi_connector" ];

  meta = {
    description = "AIOHTTP ClientSession connector for directly interacting with ASGI applications";
    homepage = "https://github.com/thearchitector/aiohttp-asgi-connector";
    changelog = "https://github.com/thearchitector/aiohttp-asgi-connector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
