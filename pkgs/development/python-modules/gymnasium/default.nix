{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, numpy
, cloudpickle
, gym-notices
, jax-jumpy
, typing-extensions
, farama-notifications
, importlib-metadata
, pythonOlder
, dill
, ffmpeg
, flax
, jax
, jaxlib
, matplotlib
, moviepy
, opencv4
, pybox2d
, pygame
, pytestCheckHook
, scipy
, stdenv
}:

buildPythonPackage rec {
  pname = "gymnasium";
  version = "1.0.0a2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "gymnasium";
    rev = "refs/tags/v${version}";
    hash = "sha256-gRr2/59TvsCzG2Ph8EF9DRwrIn7ELUKcENAT+zAyIII=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cloudpickle
    farama-notifications
    gym-notices
    jax-jumpy
    numpy
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "gymnasium" ];

  nativeCheckInputs = [
    dill
    ffmpeg
    flax
    jax
    jaxlib
    matplotlib
    moviepy
    opencv4
    pybox2d
    pygame
    pytestCheckHook
    scipy
  ];

  # if `doCheck = true` on Darwin, `jaxlib` is evaluated, which is both
  # marked as broken and throws an error during evaluation if the package is evaluated anyway.
  # disabling checks on Darwin avoids this and allows the package to be built.
  # if jaxlib is ever fixed on Darwin, remove this.
  doCheck = !stdenv.isDarwin;

  disabledTestPaths = [
    # Unpackaged mujoco-py (Openai's mujoco) is required for those tests.
    "tests/envs/mujoco/test_mujoco_custom_env.py"
    "tests/envs/mujoco/test_mujoco_rendering.py"
    "tests/envs/mujoco/test_mujoco_v5.py"

    # Those tests need to write on the filesystem which cause them to fail.
    "tests/utils/test_save_video.py"
    "tests/wrappers/test_record_video.py"
  ];

  disabledTests = [
    "test_render_modes[Reacher-v4]"
  ];

  meta = {
    description = "A standard API for reinforcement learning and a diverse set of reference environments (formerly Gym)";
    homepage = "https://github.com/Farama-Foundation/Gymnasium";
    changelog = "https://github.com/Farama-Foundation/Gymnasium/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
