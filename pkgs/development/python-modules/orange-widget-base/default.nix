{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyqt-builder
, setuptools
, setuptools-scm
, matplotlib
, orange-canvas-core
, pyqt5
, pyqtgraph
, typing-extensions
}:

buildPythonPackage rec {
  pname = "orange-widget-base";
  version = "4.19.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "biolab";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lC//xD+S8VB597rTcYscdat/ydUCq3nEjGAjQ7obMxY=";
  };

  buildInputs = [ pyqt-builder ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    orange-canvas-core
    pyqt5
    pyqtgraph
    typing-extensions
  ];

  doCheck = false;

  meta = with lib; {
    description = "Provides a base widget component for a interactive GUI based workflow";
    longDescription = "It is primarily used in the Orange data mining application.";
    homepage = "https://orangedatamining.com/";
    changelog = "https://github.com/biolab/orange-widget-base/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totoroot ];
  };
}
