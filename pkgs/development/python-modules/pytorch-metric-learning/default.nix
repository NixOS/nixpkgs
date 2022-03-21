{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, numpy
, scikit-learn
, pytestCheckHook
, pytorch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname   = "pytorch-metric-learning";
  version = "1.1.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "KevinMusgrave";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qvlxgdml22fzrs47yzqpfzak8lfdrzayvapawfz93cq8903h7qp";
  };

  propagatedBuildInputs = [
    numpy
    pytorch
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
  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    # requires FAISS (not in Nixpkgs)
    "test_accuracy_calculator_and_faiss"
    "test_global_embedding_space_tester"
    "test_with_same_parent_label_tester"
    # require network access:
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
