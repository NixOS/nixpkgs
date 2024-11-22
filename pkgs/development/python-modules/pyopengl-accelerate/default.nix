{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  numpy,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyopengl-accelerate";
  version = "3.1.7";
  format = "pyproject";

  src = fetchPypi {
    pname = "PyOpenGL-accelerate";
    inherit version;
    hash = "sha256-KxI2ISc6k59/0uwidUHjmfm11OgV1prgvbG2xwopNoA=";
  };

  nativeBuildInputs = [
    cython
    numpy
    setuptools
    wheel
  ];

  meta = {
    description = "This set of C (Cython) extensions provides acceleration of common operations for slow points in PyOpenGL 3.x";
    homepage = "https://pyopengl.sourceforge.net/";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.bsd3;
  };
}
