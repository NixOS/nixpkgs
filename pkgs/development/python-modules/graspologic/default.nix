{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pytestCheckHook,
  testfixtures,
  anytree,
  beartype,
  gensim,
  graspologic-native,
  hyppo,
  joblib,
  matplotlib,
  networkx,
  numpy,
  pot,
  scikit-learn,
  scipy,
  seaborn,
  statsmodels,
  typing-extensions,
  umap-learn,
}:

buildPythonPackage rec {
  pname = "graspologic";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graspologic-org";
    repo = "graspologic";
    rev = "refs/tags/v${version}";
    hash = "sha256-taX/4/uCQXW7yFykVHY78hJIGThEIycHwrEOZ3h1LPY=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "beartype"
    "hyppo"
    "scipy"
  ];

  dependencies = [
    anytree
    beartype
    gensim
    graspologic-native
    hyppo
    joblib
    matplotlib
    networkx
    numpy
    pot
    scikit-learn
    scipy
    seaborn
    statsmodels
    typing-extensions
    umap-learn
  ];

  env.NUMBA_CACHE_DIR = "$TMPDIR";

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
  ];
  pytestFlagsArray = [
    "tests"
    "--ignore=docs"
    "--ignore=tests/test_sklearn.py"
  ];
  disabledTests = [ "gridplot_outputs" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # SIGABRT
    "tests/test_plot.py"
    "tests/test_plot_matrix.py"
  ];

  meta = with lib; {
    description = "Package for graph statistical algorithms";
    homepage = "https://graspologic-org.github.io/graspologic";
    changelog = "https://github.com/graspologic-org/graspologic/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
