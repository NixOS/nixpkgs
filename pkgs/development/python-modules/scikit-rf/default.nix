{ stdenv
, lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, pandas
, matplotlib
, tox
, coverage
, flake8
, nbval
, pyvisa
, networkx
, ipython
, ipykernel
, ipywidgets
, jupyter-client
, sphinx-rtd-theme
, sphinx
, nbsphinx
, openpyxl
, qtpy
, pyqtgraph
, pyqt5
, setuptools
, pytestCheckHook
, pytest-cov
, pytest-mock
}:

buildPythonPackage rec {
  pname = "scikit-rf";
  version = "0.29.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scikit-rf";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sLE6rcBGUKmk5y7oO06rHON3GVIjcvnKlr6Tgddj64Y=";
  };

  buildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    pandas
  ];

  passthru.optional-dependencies = {
    plot = [
      matplotlib
    ];
    xlsx = [
      openpyxl
    ];
    netw = [
      networkx
    ];
    visa = [
      pyvisa
    ];
    docs = [
      ipython
      ipykernel
      ipywidgets
      jupyter-client
      sphinx-rtd-theme
      sphinx
      nbsphinx
      openpyxl
    ];
    qtapps = [
      qtpy
      pyqtgraph
      pyqt5
    ];
  };

  nativeCheckInputs = [
    tox
    coverage
    flake8
    pytest-cov
    pytest-mock
    nbval
    matplotlib
    pyvisa
    openpyxl
    networkx
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # test_calibration.py generates a divide by zero error on darwin
  # https://github.com/scikit-rf/scikit-rf/issues/972
  disabledTestPaths =
    lib.optional (stdenv.isAarch64 && stdenv.isDarwin)
    "skrf/calibration/tests/test_calibration.py";

  pythonImportsCheck = [
    "skrf"
  ];

  meta = with lib; {
    description = "A Python library for RF/Microwave engineering";
    homepage = "https://scikit-rf.org/";
    changelog = "https://github.com/scikit-rf/scikit-rf/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lugarun ];
  };
}
