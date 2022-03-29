{ lib
, buildPythonPackage
, fetchPypi
, flaky
, traitlets
, jupyter_core
, jupyter-client
, pygments
, ipykernel
, pyqt5
, qtpy
, pythonOlder
, pytest-qt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "5.3.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jjUg/cdeRqvEzGz/7KFvomUnVBCbiug5+ijifR66ViU=";
  };

  propagatedBuildInputs = [
    traitlets
    jupyter_core
    jupyter-client
    pygments
    ipykernel
    pyqt5
    qtpy
  ];

  checkInputs = [
    flaky
    pytest-qt
    pytestCheckHook
  ];

  # qtconsole/tests/test_00_console_widget.py Fatal Python error: Aborted
  doCheck = false;

  meta = {
    description = "Jupyter Qt console";
    homepage = "https://github.com/jupyter/qtconsole";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
