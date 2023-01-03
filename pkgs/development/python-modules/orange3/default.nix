{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyqt-builder
, setuptools
, setuptools-scm
, baycomp
, bottleneck
, chardet
, cython
, httpx
, keyring
, keyrings-alt
, openpyxl
, opentsne
, orange-canvas-core
, orange-widget-base
, pandas
, pyqtgraph
, python-louvain
, pyyaml
, qtconsole
, serverfiles
, xlrd
, XlsxWriter
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
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    baycomp
    bottleneck
    chardet
    cython
    httpx
    keyring
    keyrings-alt
    openpyxl
    opentsne
    orange-canvas-core
    orange-widget-base
    pandas
    pyqtgraph
    python-louvain
    pyyaml
    qtconsole
    serverfiles
    xlrd
    XlsxWriter
  ];

  doCheck = false;

  pythonImportsCheck = [ "Orange" ];

  meta = with lib; {
    description = "A data mining and visualization toolbox for novice and expert alike";
    homepage = "https://orangedatamining.com/";
    changelog = "https://github.com/biolab/orange3/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ totoroot ];
  };
}
