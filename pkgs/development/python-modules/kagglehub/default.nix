{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
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

buildPythonPackage rec {
  pname = "kagglehub";
  version = "0.3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kaggle";
    repo = "kagglehub";
    tag = "v${version}";
    hash = "sha256-pwQZhNtps2wZeLlMMsX0M8t6qBuEdL3m/Kjf0Qdk0PM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
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
  ++ optional-dependencies.pandas-datasets;

  disabledTestPaths = [
    # Require internet access
    "integration_tests/"
  ];

  disabledTests = [
    # Requires internet access
    "test_model_signing"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library to access Kaggle resources";
    homepage = "https://github.com/Kaggle/kagglehub";
    changelog = "https://github.com/Kaggle/kagglehub/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
