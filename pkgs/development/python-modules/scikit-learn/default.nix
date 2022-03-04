{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, gfortran
, glibcLocales
, numpy
, scipy
, pytestCheckHook
, pytest-xdist
, pillow
, cython
, joblib
, llvmPackages
, threadpoolctl
, pythonOlder
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "1.0.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tYcJWaVIS2FPJtMcpMF1JLGwMXUiGZ3JhcO0JW4DB2c=";
  };

  buildInputs = [
    pillow
    glibcLocales
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  nativeBuildInputs = [
    cython
    gfortran
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    numpy.blas
    joblib
    threadpoolctl
  ];

  checkInputs = [ pytestCheckHook pytest-xdist ];

  LC_ALL="en_US.UTF-8";

  preBuild = ''
    export SKLEARN_BUILD_PARALLEL=$NIX_BUILD_CORES
  '';

  doCheck = !stdenv.isAarch64;

  disabledTests = [
    # Skip test_feature_importance_regression - does web fetch
    "test_feature_importance_regression"

    # failing on macos
    "check_regressors_train"
    "check_classifiers_train"
    "xfail_ignored_in_check_estimator"

    # failing on x86_64-linux
    "test_kernel_pca_consistent_transform"
    "test_kernel_pca_raise_not_fitted_error"
    "test_32_64_decomposition_shape"
    "test_randomized_eigsh_reconst_low_rank"
    "test_randomized_svd_low_rank_with_noise"

    "test_row_norms"
    "test_randomized_svd_infinite_rank"
    "test_randomized_svd_transpose_consistency"
    "test_randomized_svd_sparse_warnings"
    "test_randomized_svd_sign_flip"
    "test_incremental_weighted_mean_and_variance_ignore_nan"
    "test_randomized_svd_infinite_rank"
    "test_randomized_eigsh_compared_to_others"
  ];

  pytestFlagsArray = [
    # verbose build outputs needed to debug hard-to-reproduce hydra failures
    "-v"
    "--pyargs" "sklearn"

    # NuSVC memmap tests causes segmentation faults in certain environments
    # (e.g. Hydra Darwin machines) related to a long-standing joblib issue
    # (https://github.com/joblib/joblib/issues/563). See also:
    # https://github.com/scikit-learn/scikit-learn/issues/17582
    # Since we are overriding '-k' we need to include the 'disabledTests' from above manually.
    "-k" "'not (NuSVC and memmap) and not KernelPCA ${toString (lib.forEach disabledTests (t: "and not ${t}"))}'"

    "-n" "$NIX_BUILD_CORES"
  ];

  preCheck = ''
    cd $TMPDIR
    export HOME=$TMPDIR
    export OMP_NUM_THREADS=1
  '';

  pythonImportsCheck = [ "sklearn" ];

  meta = with lib; {
    description = "A set of python modules for machine learning and data mining";
    changelog = let
      major = versions.major version;
      minor = versions.minor version;
      dashVer = replaceChars ["."] ["-"] version;
    in
      "https://scikit-learn.org/stable/whats_new/v${major}.${minor}.html#version-${dashVer}";
    homepage = "https://scikit-learn.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ davhau ];
  };
}
