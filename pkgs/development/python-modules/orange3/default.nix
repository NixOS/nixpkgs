{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyqt-builder
, libsForQt5
, setuptools
, setuptools-scm
, baycomp
, bottleneck
, chardet
, cython
, httpx
, joblib
, keyring
, keyrings-alt
, matplotlib
, numpy
, openpyxl
, opentsne
, orange-canvas-core
, orange-widget-base
, pandas
, pyqt5
, pyqtwebengine
, pyqtgraph
, python-louvain
, pyyaml
, qtconsole
, scikit-learn
, scipy
, serverfiles
, xlrd
, XlsxWriter
, xgboost
}:

buildPythonPackage rec {
  pname = "orange3";
  version = "3.34.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "biolab";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0kQRibXqDUMxVOpIlfgIkUSPWhmG5I0fG/EEde9Z+7g=";
  };

  buildInputs = [ pyqt-builder ];

  nativeBuildInputs = [
    libsForQt5.qt5.wrapQtAppsHook
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    baycomp
    bottleneck
    chardet
    cython
    httpx
    joblib
    keyring
    keyrings-alt
    matplotlib
    numpy
    openpyxl
    opentsne
    orange-canvas-core
    orange-widget-base
    pandas
    pyqt5
    pyqtgraph
    pyqtwebengine
    python-louvain
    pyyaml
    qtconsole
    scikit-learn
    scipy
    serverfiles
    xlrd
    XlsxWriter
  ];

  enableParallelBuilding = true;

  pythonImportsCheck = [ "Orange" ];

  doCheck = false;

  checkInputs = [
    xgboost
  ];

  checkPhase = ''
    python -m unittest Orange.tests Orange.widgets.tests
  '';

  meta = with lib; {
    description = "A data mining and visualization toolbox for novice and expert alike";
    homepage = "https://orangedatamining.com/";
    changelog = "https://github.com/biolab/orange3/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ totoroot ];
  };
}
