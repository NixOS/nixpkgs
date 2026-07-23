{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kaggle";
    repo = "kagglehub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HyPFGde1v++7Ef5dSLHLA2u2RfnlwM+63RAV+lulTjw=";
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
