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
}:

buildPythonPackage rec {
  pname = "scikit-rf";
  version = "0.29.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scikit-rf";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rBOw1rIEF8Ia6xXlXxVzRRiUxrOjOAlipFuKiL+gRl0=";
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
    nbval
    matplotlib
    pyvisa
    openpyxl
    networkx
  ];

  checkInputs = [
    pytestCheckHook
  ];

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
