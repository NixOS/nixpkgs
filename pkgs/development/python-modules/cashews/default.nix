{
  bitarray,
  buildPythonPackage,
  dill,
  diskcache,
  fetchFromGitHub,
  hiredis,
  hypothesis,
  lib,
  pytest,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-rerunfailures,
  pytestCheckHook,
  redis,
  setuptools,
  xxhash,
}:

buildPythonPackage rec {
  pname = "cashews";
  version = "7.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Krukov";
    repo = "cashews";
    tag = version;
    hash = "sha256-rLKaKTw7g3gpDACKZADaLiq2n5vxE/Rlsg4YKfWdFSY=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    dill = [ dill ];
    diskcache = [ diskcache ];
    redis = [ redis ];
    speedup = [
      bitarray
      hiredis
      xxhash
    ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest
    pytest-asyncio
    pytest-cov-stub
    pytest-rerunfailures
    pytestCheckHook
  ];

  disabledTests = [
    # these tests require too many dependencies
    "redis"
    "diskcache"
    "integration"
  ];

  pythonImportsCheck = [ "cashews" ];

  meta = {
    description = "Cache tools with async power";
    homepage = "https://github.com/Krukov/cashews/";
    changelog = "https://github.com/Krukov/cashews/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
