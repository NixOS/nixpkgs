{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build
  hatchling,
  # runtime
  cassandra-driver,
  motor,
  numpy,
  pybloomfiltermap3,
  redis,
  scipy,
  # check
  pytestCheckHook,
  aiounittest,
  pytest-rerunfailures,
}:

buildPythonPackage (finalAttrs: {
  pname = "datasketch";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ekzhu";
    repo = "datasketch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YyB4dGPGBX9C8l6ogT1JXlfY8/s+TooCUbEgY9qpzik=";
  };

  build-system = [ hatchling ];

  dependencies = [
    numpy
    scipy
    pybloomfiltermap3
  ];

  optional-dependencies = rec {
    cassandra = [ cassandra-driver ];
    redis = [ redis ];
    experimental_aio = [ motor ];
    all = cassandra ++ redis ++ experimental_aio;
  };

  nativeCheckInputs = [
    pytestCheckHook
    aiounittest
    motor
    pytest-rerunfailures
    redis
  ];

  disabledTestPaths = [
    # these tests import mockredis, which has been abandoned for many years
    "test/test_lsh.py"
    "test/test_lshensemble.py"
  ];
  disabledTests = [
    # flaky
    "test_soft_remove_and_pop_and_clean"
  ];

  meta = {
    changelog = "https://github.com/ekzhu/datasketch/releases/tag/v${finalAttrs.version}";
    description = "MinHash, LSH, LSH Forest, Weighted MinHash, HyperLogLog, HyperLogLog++, LSH Ensemble and HNSW";
    homepage = "https://ekzhu.com/datasketch/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
})
