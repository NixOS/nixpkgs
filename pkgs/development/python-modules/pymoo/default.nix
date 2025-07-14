{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # dependencies
  autograd,
  cma,
  deprecated,
  dill,
  matplotlib,
  numpy,
  scipy,

  # tests
  pytestCheckHook,
  nbformat,
  notebook,
  numba,
  pythonAtLeast,
  writeText,
}:

let
  pymoo_data = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo-data";
    rev = "33f61a78182ceb211b95381dd6d3edee0d2fc0f3";
    hash = "sha256-iGWPepZw3kJzw5HKV09CvemVvkvFQ38GVP+BAryBSs0=";
  };
in
buildPythonPackage rec {
  pname = "pymoo";
  version = "0.6.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo";
    tag = version;
    hash = "sha256-CbeJwv51lu4cABgGieqy/8DCDJCb8wOPPVqUHk8Jb7E=";
  };

  postPatch = ''
    substituteInPlace pymoo/util/display/display.py \
      --replace-fail "from pymoo.util.display.progress import ProgressBar" "" \
      --replace-fail \
        "ProgressBar() if progress else None" \
        "print('Missing alive_progress needed for progress=True!') if progress else None"

    substituteInPlace pymoo/algorithms/soo/nonconvex/es.py \
      --replace-fail "np.math.ceil" "np.ceil"
    substituteInPlace pymoo/util/mnn.py \
      --replace-fail "np.product" "np.prod"

    substituteInPlace pymoo/config.py \
      --replace-fail \
        "https://raw.githubusercontent.com/anyoptimization/pymoo-data/main/" \
        "file://${pymoo_data}/"
  '';

  pythonRelaxDeps = [ "cma" ];
  pythonRemoveDeps = [ "alive-progress" ];

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    autograd
    cma
    deprecated
    dill
    matplotlib
    numpy
    scipy
  ];

  preCheck = ''
    # Some tests require a grad backend to be configured, this is a hacky way to do so.
    # The choice must be either "jax.numpy" or "autograd.numpy"
    echo 'from pymoo.gradient import activate; activate("autograd.numpy")' >> tests/conftest.py
  '';
  nativeCheckInputs = [
    pytestCheckHook
    nbformat
    notebook
    numba
  ];
  # Select some lightweight tests
  pytestFlagsArray = [ "-m 'not long'" ];
  disabledTests =
    [
      # ModuleNotFoundError: No module named 'pymoo.cython.non_dominated_sorting'
      "test_fast_non_dominated_sorting"
      "test_efficient_non_dominated_sort"
      "test_dominance_degree_non_dominated_sort"

      # sensitive to float precision
      "test_cd_and_pcd"

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
  ];
  # Avoid crashing sandboxed build on macOS
  MATPLOTLIBRC = writeText "" ''
    backend: Agg
  '';

  pythonImportsCheck = [ "pymoo" ];

  meta = {
    description = "Multi-objective Optimization in Python";
    homepage = "https://pymoo.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
