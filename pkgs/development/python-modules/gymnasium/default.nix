{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,
  farama-notifications,
  numpy,
  typing-extensions,

  # optional-dependencies
  ale-py,
  array-api-compat,
  flax,
  imageio,
  jax,
  jaxlib,
  matplotlib,
  moviepy,
  mujoco,
  opencv4,
  packaging,
  pybox2d,
  pygame-ce,
  seaborn,
  torch,

  # tests
  dill,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "gymnasium";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "gymnasium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RrAGkHogVizEnkbKG2rVXRIBJEOPd9U2n/XG2qZ5HR4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cloudpickle
    farama-notifications
    numpy
    typing-extensions
  ];

  optional-dependencies = {
    atari = [ ale-py ];
    box2d = [
      pybox2d
      pygame-ce
    ];
    classic-control = [ pygame-ce ];
    mujoco = [
      imageio
      mujoco
      packaging
    ];
    toy-text = [ pygame-ce ];
    jax = [
      array-api-compat
      flax
      jax
      jaxlib
    ];
    torch = [
      array-api-compat
      torch
    ];
    array-api = [
      array-api-compat
      packaging
    ];
    other = [
      matplotlib
      moviepy
      opencv4
      seaborn
    ];
  };

  pythonImportsCheck = [ "gymnasium" ];

  nativeCheckInputs = [
    dill
    pytestCheckHook
    scipy
  ]
  # ale-py depends on gymnasium (infinite recursion)
  ++ lib.concatAttrValues (removeAttrs finalAttrs.passthru.optional-dependencies [ "atari" ]);

  # if `doCheck = true` on Darwin, `jaxlib` is evaluated, which is both
  # marked as broken and throws an error during evaluation if the package is evaluated anyway.
  # disabling checks on Darwin avoids this and allows the package to be built.
  # if jaxlib is ever fixed on Darwin, remove this.
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTestPaths = [
    # Unpackaged `mujoco-py` (Openai's mujoco) is required for these tests.
    "tests/envs/mujoco/test_mujoco_custom_env.py"
    "tests/envs/mujoco/test_mujoco_rendering.py"
    "tests/envs/mujoco/test_mujoco_v5.py"

    # Rendering tests failing in the sandbox
    "tests/wrappers/vector/test_human_rendering.py"

    # These tests need to write on the filesystem which cause them to fail.
    "tests/utils/test_save_video.py"
    "tests/wrappers/test_record_video.py"
  ];

  preCheck = ''
    export SDL_VIDEODRIVER=dummy
  '';

  disabledTests = [
    # Succeeds for most environments but `test_render_modes[Reacher-v4]` fails because it requires
    # OpenGL access which is not possible inside the sandbox.
    "test_render_mode"
  ];

  meta = {
    description = "Standard API for reinforcement learning and a diverse set of reference environments (formerly Gym)";
    homepage = "https://github.com/Farama-Foundation/Gymnasium";
    changelog = "https://github.com/Farama-Foundation/Gymnasium/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
