{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  glfw,
  mujoco-core,
  numpy,
  pyopengl,

  python,
}:

# Since 4.0.0, `mujoco` is a metapackage pulling `mujoco-core` (the actual bindings) and
# `mujoco-studio`.
buildPythonPackage (finalAttrs: {
  pname = "mujoco";
  inherit (mujoco-core) version;
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-v2aflEKIA4Vxp527uYyelNS5stl+quXJjPdfdL4vHG0=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    # Unpackaged: requires google/filament
    "mujoco-studio"
  ];
  dependencies = [
    glfw
    mujoco-core
    numpy
    pyopengl
  ];

  # Duplicate of the `mujoco/__init__.py` already shipped by mujoco-core
  postInstall = ''
    rm -r $out/${python.sitePackages}/mujoco
  '';

  pythonImportsCheck = [ "mujoco" ];

  meta = {
    description = "Python bindings for MuJoCo: a general purpose physics simulator";
    inherit (mujoco-core.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
