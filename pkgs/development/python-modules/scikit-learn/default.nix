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
  pname = "scikit-learn";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "scikit_learn";
    inherit version;
    hash = "sha256-eJ49sBx1DtbUlvott9UGN4V7RR5XvK6GO/9wfBJHvvc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0rc2" "numpy"

    substituteInPlace meson.build --replace-fail \
      "run_command('sklearn/_build_utils/version.py', check: true).stdout().strip()," \
      "'${version}',"
  '';

  buildInputs = [
    numpy.blas
    pillow
    glibcLocales
  ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  env.LC_ALL = "en_US.UTF-8";

  preBuild = ''
    export SKLEARN_BUILD_PARALLEL=$NIX_BUILD_CORES
  '';

  # PermissionError: [Errno 1] Operation not permitted: '/nix/nix-installer'
  doCheck = !stdenv.isDarwin;

  disabledTests = [
    # Skip test_feature_importance_regression - does web fetch
    "test_feature_importance_regression"
  ];

  pytestFlagsArray = [
    # verbose build outputs needed to debug hard-to-reproduce hydra failures
    "-v"
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

  meta = with lib; {
    description = "Set of python modules for machine learning and data mining";
    changelog =
      let
        major = versions.major version;
        minor = versions.minor version;
        dashVer = replaceStrings [ "." ] [ "-" ] version;
      in
      "https://scikit-learn.org/stable/whats_new/v${major}.${minor}.html#version-${dashVer}";
    homepage = "https://scikit-learn.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ davhau ];
  };
}
