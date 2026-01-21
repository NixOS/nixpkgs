{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  kagglesdk,
  packaging,
  pyyaml,
  requests,
  tqdm,

  # optional-dependencies
  # hf-datasets
  datasets,
  kagglehub,
  # pandas-datasets
  pandas,
  # polars-datasets
  polars,
  # signing
  betterproto,
  model-signing,
  sigstore,

  # tests
  fastexcel,
  flask,
  flask-jwt-extended,
  jwt,
  openpyxl,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kagglehub";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kaggle";
    repo = "kagglehub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R9yV29Yrq9it21K2GZLXMNM8MjBAG1iYb1o1azrAghM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    kagglesdk
    packaging
    pyyaml
    requests
    tqdm
  ];

  optional-dependencies = {
    hf-datasets = [
      datasets
      kagglehub
    ];
    pandas-datasets = [
      pandas
    ];
    polars-datasets = [
      polars
    ];
    signing = [
      betterproto
      model-signing
      sigstore
    ];
  };

  pythonImportsCheck = [ "kagglehub" ];

  nativeCheckInputs = [
    datasets
    fastexcel
    flask
    flask-jwt-extended
    jwt
    model-signing
    openpyxl
    polars
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.pandas-datasets;

  disabledTestPaths = [
    # Require internet access
    "integration_tests/"
  ];

  disabledTests = [
    # Requires internet access
    "test_model_signing"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # TypeError: Pickler._batch_setitems() takes 2 positional arguments but 3 were given
    "test_hf_dataset_succeeds"
    "test_hf_dataset_with_other_loader_kwargs_prints_warning"
    "test_hf_dataset_with_splits_succeeds"
    "test_hf_dataset_with_valid_kwargs_succeeds"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library to access Kaggle resources";
    homepage = "https://github.com/Kaggle/kagglehub";
    changelog = "https://github.com/Kaggle/kagglehub/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
