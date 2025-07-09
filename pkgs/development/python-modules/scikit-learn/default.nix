{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  threadpoolctl,

  # test
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "scikit-learn";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-learn";
    repo = "scikit-learn";
    tag = version;
    hash = "sha256-jZaeev69C3whBUMnGJ91jkJt3Zsh37kdKEYe27kwJp4=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace-fail \
      "run_command('sklearn/_build_utils/version.py', check: true).stdout().strip()," \
      "'${version}',"
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    writableTmpDirAsHomeHook
  ];

  env.LC_ALL = "en_US.UTF-8";

  # PermissionError: [Errno 1] Operation not permitted: '/nix/nix-installer'
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Skip test_feature_importance_regression - does web fetch
    "test_feature_importance_regression"
  ];

  disabledTestPaths = [
    "tests/test_build.py::test_openmp_parallelism_enabled"
  ];

  pytestFlags = [
    # verbose build outputs needed to debug hard-to-reproduce hydra failures
    "-v"
    "--pyargs"
    "sklearn"
  ];

  preCheck = ''
    export OMP_NUM_THREADS=1
  '';

  pythonImportsCheck = [ "sklearn" ];

  meta = {
    description = "Set of python modules for machine learning and data mining";
    changelog =
      let
        major = versions.major version;
        minor = versions.minor version;
        dashVer = replaceStrings [ "." ] [ "-" ] version;
      in
      "https://scikit-learn.org/stable/whats_new/v${major}.${minor}.html#version-${dashVer}";
    homepage = "https://scikit-learn.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ davhau ];
  };
}
