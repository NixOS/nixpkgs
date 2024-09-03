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
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Krukov";
    repo = "cashews";
    rev = "refs/tags/${version}";
    hash = "sha256-7T9M8ioeTjW7OmcHyxZ6awNfp9kVU8Hi+Lgy17jXxK4=";
  };

  build-system = [ setuptools ];

  passthru.optional-dependencies = {
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
