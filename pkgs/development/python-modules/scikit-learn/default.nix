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
  version = "0.24.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "oDNKGALmTWVgIsO/q1anP71r9LEpg0PzaIryFRgQu98=";
  };

  patches = [
    # This patch fixes compatibility with numpy 1.20. It was merged before 0.24.1 was released,
    # but for some reason was not included in the 0.24.1 release tarball.
    (fetchpatch {
      url = "https://github.com/scikit-learn/scikit-learn/commit/e7ef22c3ba2334cb3b476e95d7c083cf6b48ce56.patch";
      sha256 = "174554k1pbf92bj7wgq0xjj16bkib32ailyhwavdxaknh4bd9nmv";
    })
  ];

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
    "-k" "'not (NuSVC and memmap) ${toString (lib.forEach disabledTests (t: "and not ${t}"))}'"

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
