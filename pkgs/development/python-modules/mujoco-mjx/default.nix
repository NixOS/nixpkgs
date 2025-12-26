{
  lib,
  buildPythonPackage,

  # src / metadata
  mujoco-main,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  etils,
  importlib-resources,
  jax,
  jaxlib,
  mujoco,
  scipy,
  trimesh,
}:

buildPythonPackage {
  pname = "mujoco-mjx";
  inherit (mujoco-main) src version;

  pyproject = true;

  sourceRoot = "${mujoco-main.src.name}/mjx";

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    etils
    importlib-resources
    jax
    jaxlib
    mujoco
    scipy
    trimesh
  ]
  ++ etils.optional-dependencies.epath;

  pythonImportsCheck = [ "mujoco.mjx" ];

  meta = {
    description = "MuJoCo XLA (MJX)";
    inherit (mujoco.meta) homepage changelog license;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
