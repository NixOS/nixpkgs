{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  etils,
  mujoco,
  numpy,
  warp-lang,

  # optional-dependencies
  jax,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mujoco-warp";
  version = "3.13.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco_warp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R+YizRSaPOt4eSy6W0dRsFn+ovn+Ks05wVyd5e9lgYc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    etils
    mujoco
    numpy
    warp-lang
  ];

  optional-dependencies = {
    cpu = [
      jax
    ];
    cuda = [
      jax
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "mujoco_warp" ];

  meta = {
    description = "GPU-optimized version of the MuJoCo physics simulator, designed for NVIDIA hardware";
    homepage = "https://github.com/google-deepmind/mujoco_warp";
    changelog = "https://github.com/google-deepmind/mujoco_warp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
