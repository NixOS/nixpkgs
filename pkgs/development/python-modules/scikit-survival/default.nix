{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  eigen,

  # build-system
  cython,
  numpy,
  packaging,
  scikit-learn,
  setuptools,
  setuptools-scm,

  # dependencies
  ecos,
  joblib,
  numexpr,
  osqp,
  pandas,
  scipy,

  # tests
  polars,
  pytestCheckHook,
}:

let
  # very long tests, skipped in the main build and exercised by passthru.tests
  slowTests = [
    "test_coxph"
    "test_datasets"
    "test_ensemble_selection"
    "test_minlip"
    "test_pandas_inputs"
    "test_survival_svm"
    "test_tree"
  ];
  flakyTests =
    lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # Flaky numerical assertion (AssertionError)
      "test_baseline_predict"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # floating point mismatch on aarch64
      # 27079905.88052468 too far from 27079905.880496684
      "test_coxnet"
    ];
in
buildPythonPackage (finalAttrs: {
  pname = "scikit-survival";
  version = "0.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebp";
    repo = "scikit-survival";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vqBKw/CvYg4VLsdxm9CjeN2sfT5keeg1oWTGaFM1MZg=";
  };

  postPatch = ''
    ln -s ${lib.getInclude eigen}/include/eigen3/Eigen \
      sksurv/linear_model/src/eigen
  '';

  build-system = [
    cython
    numpy
    packaging
    scikit-learn
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "osqp"
  ];
  dependencies = [
    ecos
    joblib
    numexpr
    numpy
    osqp
    pandas
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [ "sksurv" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Hack needed to make pytest + cython work
  # https://github.com/NixOS/nixpkgs/pull/82410#issuecomment-827186298
  preCheck = ''
    rm -rf sksurv
  '';

  # These tests require polars, which is heavy; exercised via passthru
  disabledTestPaths = [
    "tests/test_dataframe.py"
    "tests/test_io.py"
    "tests/test_polars_clinical_kernel.py"
    "tests/test_polars_column.py"
    "tests/test_polars_datasets.py"
    "tests/test_polars_estimators.py"
    "tests/test_polars_preprocessing.py"
    "tests/test_polars_util.py"
  ];

  disabledTests = slowTests ++ flakyTests;

  passthru.tests.full = finalAttrs.finalPackage.overridePythonAttrs (old: {
    pname = old.pname + "-full-tests";
    nativeCheckInputs = old.nativeCheckInputs ++ [ polars ];
    disabledTests = flakyTests;
    disabledTestPaths = [ ];
  });

  meta = {
    description = "Survival analysis built on top of scikit-learn";
    homepage = "https://github.com/sebp/scikit-survival";
    changelog = "https://github.com/sebp/scikit-survival/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
