{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  writeText,
  autograd,
  cma,
  cython,
  deprecated,
  dill,
  matplotlib,
  nbformat,
  notebook,
  numba,
  numpy,
  pandas,
  scipy,
}:

buildPythonPackage rec {
  pname = "pymoo";
  version = "0.6.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo";
    rev = version;
    hash = "sha256-+qtW7hfSo266n1SRzAgHIu99W5Sl+NYbKOHXv/JI9IA=";
  };

  pymoo_data = fetchFromGitHub {
    owner = "anyoptimization";
    repo = "pymoo-data";
    rev = "33f61a78182ceb211b95381dd6d3edee0d2fc0f3";
    hash = "sha256-iGWPepZw3kJzw5HKV09CvemVvkvFQ38GVP+BAryBSs0=";
  };

  patches = [
    # https://github.com/anyoptimization/pymoo/pull/407
    (fetchpatch {
      url = "https://github.com/anyoptimization/pymoo/commit/be57ece64275469daece1e8ef12b2b6ee05362c9.diff";
      hash = "sha256-BLPrUqNbAsAecfYahESEJF6LD+kehUYmkTvl/nvyqII=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cma==3.2.2" "cma" \
      --replace "'alive-progress'," ""

    substituteInPlace pymoo/util/display/display.py \
      --replace "from pymoo.util.display.progress import ProgressBar" "" \
      --replace "ProgressBar() if progress else None" \
                "print('Missing alive_progress needed for progress=True!') if progress else None"
  '';

  nativeBuildInputs = [ cython ];
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
  nativeCheckInputs = [
    pytestCheckHook
    nbformat
    notebook
    numba
  ];
  # Select some lightweight tests
  pytestFlagsArray = [ "-m 'not long'" ];
  disabledTests = [
    # ModuleNotFoundError: No module named 'pymoo.cython.non_dominated_sorting'
    "test_fast_non_dominated_sorting"
    "test_efficient_non_dominated_sort"
  ];
  # Avoid crashing sandboxed build on macOS
  MATPLOTLIBRC = writeText "" ''
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
