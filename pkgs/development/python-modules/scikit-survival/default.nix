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
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scikit-survival";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebp";
    repo = "scikit-survival";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xtrGFNRHF8bL8Q82gIQLayuCSDFMrBBkQ63F+Nmbdes=";
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

  disabledTests = [
    # very long tests, unnecessary for a leaf package
    "test_coxph"
    "test_datasets"
    "test_ensemble_selection"
    "test_minlip"
    "test_pandas_inputs"
    "test_survival_svm"
    "test_tree"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Flaky numerical assertion (AssertionError)
    "test_baseline_predict"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # floating point mismatch on aarch64
    # 27079905.88052468 to far from 27079905.880496684
    "test_coxnet"
  ];

  meta = {
    description = "Survival analysis built on top of scikit-learn";
    homepage = "https://github.com/sebp/scikit-survival";
    changelog = "https://github.com/sebp/scikit-survival/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
