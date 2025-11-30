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

buildPythonPackage rec {
  pname = "scikit-survival";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebp";
    repo = "scikit-survival";
    tag = "v${version}";
    hash = "sha256-OvdmZ2vDptYB2tq7OtokIQzjKzhQBWwnXZLW0m6FqlI=";
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
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # floating point mismatch on aarch64
    # 27079905.88052468 to far from 27079905.880496684
    "test_coxnet"
  ];

  meta = {
    description = "Survival analysis built on top of scikit-learn";
    homepage = "https://github.com/sebp/scikit-survival";
    changelog = "https://github.com/sebp/scikit-survival/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
