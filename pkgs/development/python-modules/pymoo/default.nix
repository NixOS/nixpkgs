{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
<<<<<<< HEAD
  alive-progress,
  autograd,
  cma,
  deprecated,
  matplotlib,
  moocore,
=======
  autograd,
  cma,
  deprecated,
  dill,
  matplotlib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  numpy,
  scipy,

  # tests
<<<<<<< HEAD
  jupytext,
  nbformat,
  notebook,
  numba,
  optuna,
  pytestCheckHook,
  pythonAtLeast,
  scikit-learn,
=======
  pytestCheckHook,
  nbformat,
  notebook,
  numba,
  pythonAtLeast,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  writeText,
}:

let
  pymoo_data = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo-data";
<<<<<<< HEAD
    rev = "8dae7d02078def161ee109184399adc3db25265b";
    hash = "sha256-dpuRIMqDQ+oKrvK1VAQxPG6vijZMxT6MB8xOswPwv5o=";
=======
    tag = "33f61a78182ceb211b95381dd6d3edee0d2fc0f3";
    hash = "sha256-iGWPepZw3kJzw5HKV09CvemVvkvFQ38GVP+BAryBSs0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
buildPythonPackage rec {
  pname = "pymoo";
<<<<<<< HEAD
  version = "0.6.1.6";
=======
  version = "0.6.1.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-tLkXH0Ig/yWZbaFwzsdIdmbnlNd9UAruVSziaL3iW4U=";
=======
    hash = "sha256-IRNYluK6fO1cQq0u9dIJYnI5HWqtTPLXARXNoHa4F0I=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pymoo/util/display/display.py \
      --replace-fail "from pymoo.util.display.progress import ProgressBar" "" \
      --replace-fail \
        "ProgressBar() if progress else None" \
        "print('Missing alive_progress needed for progress=True!') if progress else None"

    substituteInPlace pymoo/config.py \
      --replace-fail \
        "https://raw.githubusercontent.com/anyoptimization/pymoo-data/main/" \
        "file://${pymoo_data}/"
  '';

<<<<<<< HEAD
=======
  pythonRelaxDeps = [ "cma" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonRemoveDeps = [ "alive-progress" ];

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
<<<<<<< HEAD
    alive-progress
    autograd
    cma
    deprecated
    matplotlib
    moocore
=======
    autograd
    cma
    deprecated
    dill
    matplotlib
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    numpy
    scipy
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    jupytext
    nbformat
    notebook
    numba
    optuna
    pytestCheckHook
    scikit-learn
=======
  # Some tests require a grad backend to be configured, this is a hacky way to do so.
  # The choice must be either "jax.numpy" or "autograd.numpy"
  preCheck = ''
    echo 'from pymoo.gradient import activate; activate("autograd.numpy")' >> tests/conftest.py
  '';
  nativeCheckInputs = [
    pytestCheckHook
    nbformat
    notebook
    numba
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
  # Select some lightweight tests
  disabledTestMarks = [ "long" ];
  disabledTests = [
    # ModuleNotFoundError: No module named 'pymoo.cython.non_dominated_sorting'
    "test_fast_non_dominated_sorting"
    "test_efficient_non_dominated_sort"
    "test_dominance_degree_non_dominated_sort"

    # sensitive to float precision
    "test_cd_and_pcd"

    # AssertionError:
    # Not equal to tolerance rtol=0, atol=0.0001
    # Mismatched elements: 1200 / 1200 (100%)
    "test_pf"

    # TypeError: 'NoneType' object is not subscriptable
    "test_dascomp"
    "test_mw"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # AttributeError: 'ZDT3' object has no attribute 'elementwise'
    "test_kktpm_correctness"
  ];
<<<<<<< HEAD

  disabledTestPaths = [
    # sensitive to float precision
    "tests/algorithms/test_no_modfication.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # sensitive to float precision
    "tests/misc/test_kktpm.py::test_kktpm_correctness[zdt3-params3]"
  ];

  # Avoid crashing sandboxed build on macOS
  env.MATPLOTLIBRC = writeText "" ''
=======
  disabledTestPaths = [
    # sensitive to float precision
    "tests/algorithms/test_no_modfication.py"
  ];
  # Avoid crashing sandboxed build on macOS
  MATPLOTLIBRC = writeText "" ''
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    backend: Agg
  '';

  pythonImportsCheck = [ "pymoo" ];

  meta = {
    description = "Multi-objective Optimization in Python";
    homepage = "https://pymoo.org/";
<<<<<<< HEAD
    downloadPage = "https://github.com/anyoptimization/pymoo";
    changelog = "https://github.com/anyoptimization/pymoo/releases/tag/${src.tag}";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
