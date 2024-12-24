{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  config,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scikit-learn,
  torch,
  tqdm,

  # optional-dependencies
  faiss,
  tensorboard,

  # tests
  cudaSupport ? config.cudaSupport,
  pytestCheckHook,
  torchvision,
}:

buildPythonPackage rec {
  pname = "pytorch-metric-learning";
  version = "2.7.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "KevinMusgrave";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mxAl4GMyAWtvocc68Ac3z1+W13k9OOK7aQFfB7X0f9c=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    torch
    scikit-learn
    tqdm
  ];

  optional-dependencies = {
    with-hooks = [
      # TODO: record-keeper
      faiss
      tensorboard
    ];
    with-hooks-cpu = [
      # TODO: record-keeper
      faiss
      tensorboard
    ];
  };

  preCheck = ''
    export HOME=$TMP
    export TEST_DEVICE=cpu
    export TEST_DTYPES=float32,float64  # half-precision tests fail on CPU
  '';

  # package only requires `unittest`, but use `pytest` to exclude tests
  nativeCheckInputs = [
    pytestCheckHook
    torchvision
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests =
    [
      # network access
      "test_tuplestoweights_sampler"
      "test_metric_loss_only"
      "test_add_to_indexer"
      "test_get_nearest_neighbors"
      "test_list_of_text"
      "test_untrained_indexer"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # AttributeError: module 'torch.distributed' has no attribute 'init_process_group'
      "test_single_proc"
    ]
    ++ lib.optionals cudaSupport [
      # crashes with SIGBART
      "test_accuracy_calculator_and_faiss_with_torch_and_numpy"
      "test_accuracy_calculator_large_k"
      "test_custom_knn"
      "test_global_embedding_space_tester"
      "test_global_two_stream_embedding_space_tester"
      "test_index_type"
      "test_k_warning"
      "test_many_tied_distances"
      "test_query_within_reference"
      "test_tied_distances"
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
