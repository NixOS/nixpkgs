{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  etils,
  mujoco-core,
  numpy,
  warp-lang,

  # optional-dependencies
  jax,
  pillow,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mujoco-warp";
  inherit (mujoco-core) version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "mujoco_warp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f/SNbWrit7mCarA0nhh0nzTe8M0sAFtGvs+KniqLw1o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    etils
    mujoco-core
    numpy
    warp-lang
  ];

  optional-dependencies = {
    viewer = [
      pillow
    ]
    ++ mujoco-core.optional-dependencies.rendering;
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
