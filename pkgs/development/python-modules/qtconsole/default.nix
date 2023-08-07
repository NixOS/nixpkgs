{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, jupyter-core
, jupyter-client
, ipython_genutils
, pygments
, pyqt5
, pytestCheckHook
, pythonOlder
, pyzmq
, qtpy
, traitlets
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "5.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XkCCqGogF5aypc/UKYNS0isVi1G1dzZTGCRxX8Kped0=";
  };

  propagatedBuildInputs = [
    ipykernel
    ipython_genutils
    jupyter-core
    jupyter-client
    pygments
    pyqt5
    pyzmq
    qtpy
    traitlets
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # : cannot connect to X server
  doCheck = false;

  pythonImportsCheck = [
    "qtconsole"
  ];

  meta = with lib; {
    description = "Jupyter Qt console";
    homepage = "https://qtconsole.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
    platforms = platforms.unix;
  };
}
