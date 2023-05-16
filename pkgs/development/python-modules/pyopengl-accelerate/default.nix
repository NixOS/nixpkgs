{ lib
, buildPythonPackage
, pythonAtLeast
, fetchPypi
<<<<<<< HEAD
, cython_3
, numpy
, setuptools
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pyopengl-accelerate";
<<<<<<< HEAD
  version = "3.1.7";
  format = "pyproject";
=======
  version = "3.1.6";
  disabled = pythonAtLeast "3.10"; # fails to compile
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "PyOpenGL-accelerate";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-KxI2ISc6k59/0uwidUHjmfm11OgV1prgvbG2xwopNoA=";
  };

  nativeBuildInputs = [
    cython_3
    numpy
    setuptools
    wheel
  ];

=======
    hash = "sha256-rYowAlbsolIoJh3hb3QeUaMPNPHhsc9oNZ9cYtvNzcM=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "This set of C (Cython) extensions provides acceleration of common operations for slow points in PyOpenGL 3.x";
    homepage = "https://pyopengl.sourceforge.net/";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.bsd3;
  };
}
