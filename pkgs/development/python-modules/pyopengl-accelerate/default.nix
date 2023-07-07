{ lib
, buildPythonPackage
, pythonAtLeast
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyopengl-accelerate";
  version = "3.1.7";
  disabled = pythonAtLeast "3.10"; # fails to compile

  src = fetchPypi {
    pname = "PyOpenGL-accelerate";
    inherit version;
    hash = "sha256-KxI2ISc6k59/0uwidUHjmfm11OgV1prgvbG2xwopNoA=";
  };

  meta = {
    description = "This set of C (Cython) extensions provides acceleration of common operations for slow points in PyOpenGL 3.x";
    homepage = "https://pyopengl.sourceforge.net/";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.bsd3;
  };
}
