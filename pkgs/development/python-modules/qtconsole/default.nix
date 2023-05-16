{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, jupyter-core
, jupyter-client
<<<<<<< HEAD
, ipython_genutils
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "5.4.4";
=======
  version = "5.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-t/+1PXTyPO4p9M21Xdb6vI7DEtlPPEa6OOHd5FhpPfs=";
=======
    hash = "sha256-V3SOov0mMgoLd626IBMc+7E4GMfJbYP6/LEQ/1X1izU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    ipykernel
<<<<<<< HEAD
    ipython_genutils
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
