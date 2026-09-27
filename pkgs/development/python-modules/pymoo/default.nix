{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  alive-progress,
  autograd,
  cma,
  deprecated,
  matplotlib,
  moocore,
  numpy,
  scipy,

  # tests
  jupytext,
  nbformat,
  notebook,
  numba,
  optuna,
  pytestCheckHook,
  pythonAtLeast,
  scikit-learn,
  writeText,
}:

let
  pymoo_data = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo-data";
    rev = "8dae7d02078def161ee109184399adc3db25265b";
    hash = "sha256-dpuRIMqDQ+oKrvK1VAQxPG6vijZMxT6MB8xOswPwv5o=";
  };
in
buildPythonPackage rec {
  pname = "pymoo";
  version = "0.6.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo";
    tag = version;
    hash = "sha256-tLkXH0Ig/yWZbaFwzsdIdmbnlNd9UAruVSziaL3iW4U=";
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

  pythonRemoveDeps = [ "alive-progress" ];

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    alive-progress
    autograd
    cma
    deprecated
    matplotlib
    moocore
    numpy
    scipy
  ];

  nativeCheckInputs = [
    jupytext
    nbformat
    notebook
    numba
    optuna
    pytestCheckHook
    scikit-learn
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
    backend: Agg
  '';

  pythonImportsCheck = [ "pymoo" ];

  meta = {
    description = "Multi-objective Optimization in Python";
    homepage = "https://pymoo.org/";
    downloadPage = "https://github.com/anyoptimization/pymoo";
    changelog = "https://github.com/anyoptimization/pymoo/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
