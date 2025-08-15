{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  cassandra-driver,
  redis,
  motor,
  pytestCheckHook,
  aiounittest,
}:

buildPythonPackage rec {
  pname = "datasketch";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ekzhu";
    repo = "datasketch";
    tag = "v${version}";
    hash = "sha256-jq2X5KEkakBV+xTfNcj417RX5FmtueF4UWn5q9NMFGA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
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
    redis
    motor
  ];

  disabledTestPaths = [
    # these tests import mockredis, which has been abandoned for many years
    "test/test_hyperloglog.py"
    "test/test_lsh.py"
    "test/test_lshensemble.py"
  ];

  disabledTests = [ "test_pickle" ];

  meta = {
    changelog = "https://github.com/ekzhu/datasketch/releases/tag/v${version}";
    description = "MinHash, LSH, LSH Forest, Weighted MinHash, HyperLogLog, HyperLogLog++, LSH Ensemble and HNSW";
    homepage = "https://ekzhu.com/datasketch/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
}
