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
  version = "3.1.9";
  format = "pyproject";

  src = fetchPypi {
    pname = "pyopengl_accelerate";
    inherit version;
    hash = "sha256-hZV8fHaXWBj/dZ7JJD+dxwke9vNz6jei61DDIP2ahvM=";
  };
  build-system = [
    cython
    numpy
    setuptools
    wheel
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=int-conversion"
    "-Wno-error=incompatible-pointer-types"
  ];

  meta = {
    description = "This set of C (Cython) extensions provides acceleration of common operations for slow points in PyOpenGL 3.x";
    homepage = "https://pyopengl.sourceforge.net/";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.bsd3;
  };
}
