{ lib
, buildPythonPackage
, fetchPypi
, notebook
, qtconsole
<<<<<<< HEAD
, jupyter-console
=======
, jupyter_console
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nbconvert
, ipykernel
, ipywidgets
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "jupyter";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9dc4b3318f310e34c82951ea5d6683f67bed7def4b259fafbfe4f1beb1d8e5f";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [ notebook qtconsole jupyter-console nbconvert ipykernel ipywidgets ];
=======
  propagatedBuildInputs = [ notebook qtconsole jupyter_console nbconvert ipykernel ipywidgets ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Meta-package, no tests
  doCheck = false;

  meta = with lib; {
    description = "Installs all the Jupyter components in one go";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
    priority = 100; # This is a metapackage which is unimportant
  };

}
