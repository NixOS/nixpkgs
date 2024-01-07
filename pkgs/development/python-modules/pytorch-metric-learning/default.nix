{ stdenv
, lib
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
  version = "2.4.1";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "KevinMusgrave";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-LftT/ATrvEkVJPS63LSN/7vCsHhobm6xk8hFEa+wrzE=";
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
  nativeCheckInputs = [
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
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
    "test_global_embedding_space_tester"
    "test_with_same_parent_label_tester"
  ];

  meta = {
    description = "Metric learning library for PyTorch";
    homepage = "https://github.com/KevinMusgrave/pytorch-metric-learning";
    changelog = "https://github.com/KevinMusgrave/pytorch-metric-learning/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
