{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  anytree,
  beartype,
  future,
=======
  poetry-core,
  poetry-dynamic-versioning,
  pytestCheckHook,
  testfixtures,
  anytree,
  beartype,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD

  # tests
  pytestCheckHook,
  testfixtures,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "graspologic";
<<<<<<< HEAD
  version = "3.4.4";
=======
  version = "3.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graspologic-org";
    repo = "graspologic";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-ulsb7jD/tIVEISjnNRif7VO+ZcXCAGIFl1SNZhOC7ik=";
  };

  # Fix numpy 2 compat
  postPatch = ''
    substituteInPlace graspologic/utils/utils.py \
      --replace-fail "np.float_" "np.float64"
    substituteInPlace graspologic/embed/omni.py \
      --replace-fail \
        "A = np.array(graphs, copy=False, ndmin=3)" \
        "A = np.asarray(graphs)"
  '';

=======
    rev = "refs/tags/v${version}";
    hash = "sha256-taX/4/uCQXW7yFykVHY78hJIGThEIycHwrEOZ3h1LPY=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "beartype"
    "hyppo"
<<<<<<< HEAD
    "numpy"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "scipy"
  ];

  dependencies = [
    anytree
    beartype
<<<<<<< HEAD
    future
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  enabledTestPaths = [
    "tests"
  ];

  disabledTests = [ "gridplot_outputs" ];

  disabledTestPaths = [
    "docs"
<<<<<<< HEAD
=======
    "tests/test_sklearn.py"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # SIGABRT
    "tests/test_plot.py"
    "tests/test_plot_matrix.py"
<<<<<<< HEAD

    # Hang forever
    "tests/pipeline/embed/"
  ];

  meta = {
    description = "Package for graph statistical algorithms";
    homepage = "https://graspologic-org.github.io/graspologic";
    changelog = "https://github.com/graspologic-org/graspologic/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
=======
  ];

  meta = with lib; {
    description = "Package for graph statistical algorithms";
    homepage = "https://graspologic-org.github.io/graspologic";
    changelog = "https://github.com/graspologic-org/graspologic/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
