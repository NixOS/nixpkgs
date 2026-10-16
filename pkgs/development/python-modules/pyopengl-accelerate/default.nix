{
  buildPythonPackage,
  cython,
  numpy,
  pyopengl,
  setuptools,
}:

buildPythonPackage {
  pname = "pyopengl-accelerate";
  pyproject = true;

  inherit (pyopengl) version src;

  sourceRoot = "${pyopengl.src.name}/accelerate";

  build-system = [
    cython
    numpy
    setuptools
  ];

  meta = {
    description = "This set of C (Cython) extensions provides acceleration of common operations for slow points in PyOpenGL 3.x";
    homepage = "https://github.com/mcfletch/pyopengl/tree/master/accelerate#readme";
    inherit (pyopengl.meta) maintainers license;
  };
}
