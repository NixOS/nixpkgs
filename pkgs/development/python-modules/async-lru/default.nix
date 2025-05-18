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
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    tag = "v${version}";
    hash = "sha256-FJ1q6W9IYs0OSMZc+bI4v22hOAAWAv2OW3BAqixm8Hs=";
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

  meta = with lib; {
    changelog = "https://github.com/aio-libs/async-lru/releases/tag/${src.tag}";
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
