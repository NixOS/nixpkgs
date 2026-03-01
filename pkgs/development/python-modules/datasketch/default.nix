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
  pybloomfilter3,
  redis,
  scipy,
  # check
  pytestCheckHook,
  aiounittest,
  mock,
  pymongo,
  pytest-asyncio,
  pytest-rerunfailures,

}:

buildPythonPackage (finalAttrs: {
  pname = "datasketch";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ekzhu";
    repo = "datasketch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ijBkbY6OioK5RP8zAeCnwlbrwE0OHa4tbEnCOabLTqs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov-report=xml" ""
  '';

  build-system = [ hatchling ];

  dependencies = [
    numpy
    scipy
  ];

  optional-dependencies = rec {
    cassandra = [ cassandra-driver ];
    redis = [ redis ];
    experimental_aio = [
      motor
      aiounittest
    ];
    bloom = [ pybloomfilter3 ];
    all = cassandra ++ redis ++ experimental_aio ++ bloom;
  };

  nativeCheckInputs = [
    pytestCheckHook
    cassandra-driver
    mock
    motor
    redis
    pybloomfilter3
    pymongo
    pytest-rerunfailures
    pytest-asyncio
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
