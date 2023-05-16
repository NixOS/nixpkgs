{ lib
, astropy
<<<<<<< HEAD
, buildPythonPackage
=======
, astropy-helpers
, buildPythonPackage
, cython
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchpatch
, fetchPypi
, matplotlib
, numpy
, pillow
, pyavm
, pyregion
, pytest-astropy
, pytestCheckHook
, pythonOlder
, reproject
<<<<<<< HEAD
, scikit-image
, setuptools
, setuptools-scm
, shapely
, wheel
=======
, scikitimage
, shapely
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "aplpy";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "aplpy";
    inherit version;
    hash = "sha256-KCdmBwQWt7IfHsjq7pWlbSISEpfQZDyt+SQSTDaUCV4=";
  };

  nativeBuildInputs = [
<<<<<<< HEAD
    setuptools
    setuptools-scm
    wheel
=======
    astropy-helpers
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    astropy
<<<<<<< HEAD
=======
    cython
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    matplotlib
    numpy
    pillow
    pyavm
    pyregion
    reproject
<<<<<<< HEAD
    scikit-image
=======
    scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    shapely
  ];

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  preCheck = ''
    OPENMP_EXPECTED=0
  '';

  pythonImportsCheck = [
    "aplpy"
  ];

  meta = with lib; {
    description = "The Astronomical Plotting Library in Python";
    homepage = "http://aplpy.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
