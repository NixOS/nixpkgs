{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  meson-python,

  # nativeBuildInputs
  cython,
  gfortran,
  numpy,
  scipy,

  # dependencies
  glibcLocales,
  joblib,
  llvmPackages,
  pillow,
  pytest-xdist,
  pytestCheckHook,
  threadpoolctl,
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-learn";
    repo = "scikit-learn";
    tag = version;
    hash = "sha256-U5c79YeCK8tbKgWY2fWQE0BMjTcwn4kJO3QyQY3wOlI=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace-fail \
      "run_command('sklearn/_build_utils/version.py', check: true).stdout().strip()," \
      "'${version}',"
    substituteInPlace pyproject.toml \
      --replace-fail "\"numpy>=2,<2.3.0\"," "\"numpy>=2,<2.4.0\","
  '';

  build-system = [
    meson-python
  ];

  nativeBuildInputs = [
    cython
    gfortran
    glibcLocales
    numpy
    numpy.blas
    pillow
    scipy
  ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  dependencies = [
    joblib
    numpy
    scipy
    threadpoolctl
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  env.LC_ALL = "en_US.UTF-8";

  disabledTests = [
    # Skip test_feature_importance_regression - does web fetch
    "test_feature_importance_regression"
  ];

  disabledTestPaths = [
    "tests/test_build.py::test_openmp_parallelism_enabled"
  ];

  pytestFlagsArray = [
    "--pyargs"
    "sklearn"

    # NuSVC memmap tests causes segmentation faults in certain environments
    # (e.g. Hydra Darwin machines) related to a long-standing joblib issue
    # (https://github.com/joblib/joblib/issues/563). See also:
    # https://github.com/scikit-learn/scikit-learn/issues/17582
    # Since we are overriding '-k' we need to include the 'disabledTests' from above manually.
    "-k"
    "'not (NuSVC and memmap) ${toString (lib.forEach disabledTests (t: "and not ${t}"))}'"
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
    maintainers = with lib.maintainers; [
      davhau
      sarahec
    ];
  };
}
