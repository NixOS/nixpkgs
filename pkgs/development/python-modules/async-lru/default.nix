{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "async-lru";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    tag = "v${version}";
    hash = "sha256-ab0l3JrjMPudfMsn0Tu2UpvSt8HePEl8tYF2EybmXak=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
  ];

  pythonImportsCheck = [ "async_lru" ];

  meta = {
    changelog = "https://github.com/aio-libs/async-lru/releases/tag/${src.tag}";
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
