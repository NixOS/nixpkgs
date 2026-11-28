{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiorwlock";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiorwlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8bphLyarlnAlUKEkcuRzcbAJgA7XcC+pqNhUYd4+xak=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiorwlock" ];

  meta = {
    description = "Read write lock for asyncio";
    homepage = "https://github.com/aio-libs/aiorwlock";
    changelog = "https://github.com/aio-libs/aiorwlock/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
  };
})
