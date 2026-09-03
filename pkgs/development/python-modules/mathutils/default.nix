{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  eigen,
}:

buildPythonPackage (finalAttrs: {
  pname = "mathutils";
  version = "5.1.0";
  pyproject = true;

  # No tags on GitLab
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sXGvnWtUoSE4yd6tT1kwo/qvkjh8xf+qgvGPvuFVQWg=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    eigen
  ];

  pythonImportsCheck = [ "mathutils" ];

  # no tests
  doCheck = false;

  meta = {
    description = "General math utilities library providing Matrix, Vector, Quaternion, Euler and Color classes, written in C for speed";
    homepage = "https://gitlab.com/ideasman42/blender-mathutils";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ autra ];
  };
})
