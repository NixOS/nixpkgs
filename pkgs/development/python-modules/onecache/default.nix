{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-asyncio,
  setuptools,
  stdenv,
}:

buildPythonPackage rec {
  pname = "onecache";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sonic182";
    repo = "onecache";
    tag = version;
    hash = "sha256-1Evrz74vvVXFAE5mmOnVE6RWgH81ocfeAQ7ZTsmTSfg=";
  };

  build-system = [
    cython
    setuptools
  ];

  env.ONECACHE_REQUIRE_EXTENSIONS = "1";

  preCheck = ''
    rm -r onecache
  '';

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
    maintainers = with lib.maintainers; [
      geraldog
      sonic182
    ];
  };
}
