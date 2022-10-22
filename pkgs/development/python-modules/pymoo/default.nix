{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, writeText
, autograd
, cma
, cython
, deprecated
, dill
, matplotlib
, nbformat
, notebook
, numba
, numpy
, pandas
, scipy
}:

buildPythonPackage rec {
  pname = "pymoo";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo";
    rev = version;
    sha256 = "sha256-dzKr+u84XmPShWXFjH7V9KzwJPGZz3msGOe1S7FlGTQ=";
  };

  pymoo_data = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo-data";
    rev = "33f61a78182ceb211b95381dd6d3edee0d2fc0f3";
    sha256 = "sha256-iGWPepZw3kJzw5HKV09CvemVvkvFQ38GVP+BAryBSs0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cma==3.2.2" "cma" \
      --replace "'alive-progress'," ""

    substituteInPlace pymoo/util/display/display.py \
      --replace "from pymoo.util.display.progress import ProgressBar" "" \
      --replace "ProgressBar() if progress else None" \
                "print('Missing alive_progress needed for progress=True!') if progress else None"
  '';

  nativeBuildInputs = [
    cython
  ];
  propagatedBuildInputs = [
    autograd
    cma
    deprecated
    dill
    matplotlib
    numpy
    scipy
  ];

  doCheck = true;
  preCheck = ''
    substituteInPlace pymoo/config.py \
      --replace "https://raw.githubusercontent.com/anyoptimization/pymoo-data/main/" \
                "file://$pymoo_data/"
  '';
  checkInputs = [
    pytestCheckHook
    nbformat
    notebook
    numba
  ];
  # Select some lightweight tests
  pytestFlagsArray = [
    "-m 'not long'"
  ];
  disabledTests = [
    # ModuleNotFoundError: No module named 'pymoo.cython.non_dominated_sorting'
    "test_fast_non_dominated_sorting"
    "test_efficient_non_dominated_sort"
  ];
  # Avoid crashing sandboxed build on macOS
  MATPLOTLIBRC=writeText "" ''
    backend: Agg
  '';

  pythonImportsCheck = [ "pymoo" ];

  meta = with lib; {
    description = "Multi-objective Optimization in Python";
    homepage = "https://pymoo.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
  };
}
