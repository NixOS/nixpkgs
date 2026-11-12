{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "async-lru";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QhzAHU9y1Wdckd6ZrdVvSU0BcO3TaTr6X5QrPNQ/pvM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
  ];

  pythonImportsCheck = [ "async_lru" ];

  meta = {
    changelog = "https://github.com/aio-libs/async-lru/releases/tag/${finalAttrs.src.tag}";
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
