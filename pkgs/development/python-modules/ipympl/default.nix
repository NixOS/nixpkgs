{ lib
, buildPythonPackage
<<<<<<< HEAD
, pythonOlder
, fetchPypi
, ipykernel
, ipython_genutils
, ipywidgets
, matplotlib
, numpy
, pillow
, traitlets
=======
, fetchPypi
, ipykernel
, ipywidgets
, matplotlib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.9.3";
  format = "wheel";

<<<<<<< HEAD
  disabled = pythonOlder "3.5";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-0RPNVYkbr+myfvmbbdERqHvra7KuVQxAQpInIQO+gBM=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
    ipykernel
    ipython_genutils
    ipywidgets
    matplotlib
    numpy
    pillow
    traitlets
  ];
=======

  propagatedBuildInputs = [ ipykernel ipywidgets matplotlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # There are no unit tests in repository
  doCheck = false;
  pythonImportsCheck = [ "ipympl" "ipympl.backend_nbagg" ];

  meta = with lib; {
    description = "Matplotlib Jupyter Extension";
    homepage = "https://github.com/matplotlib/jupyter-matplotlib";
    maintainers = with maintainers; [ jluttine fabiangd ];
    license = licenses.bsd3;
  };
}
