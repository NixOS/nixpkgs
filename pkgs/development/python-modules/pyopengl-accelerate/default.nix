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

  postPatch = ''
    substituteInPlace src/numpy_formathandler.pyx \
      --replace-fail 'Py_intptr_t' 'npy_intp'
  '';

  nativeBuildInputs = [
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
