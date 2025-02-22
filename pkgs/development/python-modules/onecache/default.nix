{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-asyncio,
  stdenv,
}:

buildPythonPackage rec {
  pname = "onecache";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "onecache";
    rev = "refs/tags/${version}";
    hash = "sha256-go/3HntSLzzTmHS9CxGPHT6mwXl+6LuWFmkGygGIjqU=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # test fails due to unknown reason on darwin
    "test_lru_and_ttl_refresh"
  ];

  pythonImportsCheck = [ "onecache" ];

  meta = {
    changelog = "https://github.com/sonic182/onecache/blob/${version}/CHANGELOG.md";
    description = "Python LRU and TTL cache for sync and async code";
    license = lib.licenses.mit;
    homepage = "https://github.com/sonic182/onecache";
    maintainers = with lib.maintainers; [ geraldog ];
  };
}
