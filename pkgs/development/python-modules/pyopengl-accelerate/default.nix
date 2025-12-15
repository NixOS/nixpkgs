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
  version = "3.1.10";
  format = "pyproject";

  src = fetchPypi {
    pname = "pyopengl_accelerate";
    inherit version;
    hash = "sha256-gnUcg/Cm9zK4tZI5kO3CRB04F2qYdWsXGOjWxDefWnE=";
  };

  build-system = [
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
