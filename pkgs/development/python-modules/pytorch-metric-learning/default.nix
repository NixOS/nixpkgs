{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, numpy
, scikit-learn
, pytestCheckHook
, torch
, torchvision
, tqdm
, faiss
}:

buildPythonPackage rec {
  pname   = "pytorch-metric-learning";
  version = "1.6.3";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "KevinMusgrave";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7ezD3TMmNI9wRBXz5Htz10XZZaSsD0jTpEldGpIot8k=";
  };

  propagatedBuildInputs = [
    numpy
    torch
    scikit-learn
    torchvision
    tqdm
  ];

  preCheck = ''
    export HOME=$TMP
    export TEST_DEVICE=cpu
    export TEST_DTYPES=float32,float64  # half-precision tests fail on CPU
  '';

  # package only requires `unittest`, but use `pytest` to exclude tests
  checkInputs = [
    faiss
    pytestCheckHook
  ];

  disabledTests = [
    # TypeError: setup() missing 1 required positional argument: 'world_size'
    "TestDistributedLossWrapper"
    # require network access:
    "TestInference"
    "test_get_nearest_neighbors"
    "test_tuplestoweights_sampler"
    "test_untrained_indexer"
    "test_metric_loss_only"
    "test_pca"
    # flaky
    "test_distributed_classifier_loss_and_miner"
  ];

  meta = {
    description = "Metric learning library for PyTorch";
    homepage = "https://github.com/KevinMusgrave/pytorch-metric-learning";
    changelog = "https://github.com/KevinMusgrave/pytorch-metric-learning/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
