{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  lib,
  pydantic,
  pydantic-settings,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypaperless";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tb1337";
    repo = "paperless-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TlukfZkoM25XWwWoj5zxjBmglHO8D9TPJPiSN2ea00U=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "pydantic-settings"
  ];

  dependencies = [
    httpx
    pydantic
    pydantic-settings
  ];

  pythonImportsCheck = [ "pypaperless" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-httpx
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/tb1337/paperless-api/releases/tag/${finalAttrs.src.tag}";
    description = "Little api client for paperless(-ngx)";
    homepage = "https://github.com/tb1337/paperless-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
