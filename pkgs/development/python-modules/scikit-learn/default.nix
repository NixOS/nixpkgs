{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  cython,
  gfortran,
  meson-python,
  numpy,
  scipy,

  # native dependencies
  glibcLocales,
  llvmPackages,
  pytestCheckHook,
  pytest-xdist,
  pillow,
  joblib,
  threadpoolctl,
  pythonOlder,
}:

buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "scikit-learn";
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "scikit_learn";
    inherit version;
    hash = "sha256-JLPx6XakZlqnTuD8qsK4/Mxq53yOB6sl2jum0ykrmAI=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace-fail \
      "run_command('sklearn/_build_utils/version.py', check: true).stdout().strip()," \
      "'${version}',"
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2,<2.3.0" numpy \
      --replace-fail "scipy>=1.8.0,<1.16.0" scipy
  '';

  buildInputs = [
    numpy.blas
    pillow
    glibcLocales
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  nativeBuildInputs = [
    gfortran
  ];

  build-system = [
    cython
    meson-python
    numpy
    scipy
  ];

  dependencies = [
    joblib
    numpy
    scipy
    threadpoolctl
  ];

  pythonRelaxDeps = [
    "numpy"
    "scipy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  env.LC_ALL = "en_US.UTF-8";

  # PermissionError: [Errno 1] Operation not permitted: '/nix/nix-installer'
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Skip test_feature_importance_regression - does web fetch
    "test_feature_importance_regression"

    # Fail due to new deprecation warnings in scipy
    # FIXME: reenable when fixed upstream
    "test_logistic_regression_path_convergence_fail"
    "test_linalg_warning_with_newton_solver"
    "test_newton_cholesky_fallback_to_lbfgs"

    # NuSVC memmap tests causes segmentation faults in certain environments
    # (e.g. Hydra Darwin machines) related to a long-standing joblib issue
    # (https://github.com/joblib/joblib/issues/563). See also:
    # https://github.com/scikit-learn/scikit-learn/issues/17582
    "NuSVC and memmap"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # doesn't seem to produce correct results?
    # possibly relevant: https://github.com/scikit-learn/scikit-learn/issues/25838#issuecomment-2308650816
    "test_sparse_input"
  ];

  pytestFlags = [
    # verbose build outputs needed to debug hard-to-reproduce hydra failures
    "-v"
    "--pyargs"
    "sklearn"
  ];

  preCheck = ''
    cd $TMPDIR
    export HOME=$TMPDIR
    export OMP_NUM_THREADS=1
  '';

  pythonImportsCheck = [ "sklearn" ];

  meta = {
    description = "Set of python modules for machine learning and data mining";
    changelog =
      let
        major = lib.versions.major version;
        minor = lib.versions.minor version;
        dashVer = lib.replaceStrings [ "." ] [ "-" ] version;
      in
      "https://scikit-learn.org/stable/whats_new/v${major}.${minor}.html#version-${dashVer}";
    homepage = "https://scikit-learn.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ davhau ];
  };
}
