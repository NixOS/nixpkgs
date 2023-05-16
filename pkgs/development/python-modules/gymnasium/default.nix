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
<<<<<<< HEAD
, ffmpeg
, jax
, jaxlib
, matplotlib
, moviepy
, opencv4
, pybox2d
, pygame
, pytestCheckHook
, scipy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "gymnasium";
<<<<<<< HEAD
  version = "0.29.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "gymnasium";
    rev = "refs/tags/v${version}";
    hash = "sha256-L7fn9FaJzXwQhjDKwI9hlFpbPuQdwynU+Xjd8bbjxiw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cloudpickle
    farama-notifications
    gym-notices
    jax-jumpy
    numpy
    typing-extensions
=======
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7rRF21H3IxbgmqxvtC370kr0exLgfg3e2tA3J49xuao=";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jax-jumpy
    cloudpickle
    numpy
    gym-notices
    typing-extensions
    farama-notifications
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "gymnasium" ];

<<<<<<< HEAD
  nativeCheckInputs = [
    ffmpeg
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

  disabledTestPaths = [
    # mujoco is required for those tests but the mujoco python bindings are not packaged in nixpkgs.
    "tests/envs/mujoco/test_mujoco_custom_env.py"

    # Those tests need to write on the filesystem which cause them to fail.
    "tests/experimental/wrappers/test_record_video.py"
    "tests/utils/test_save_video.py"
    "tests/wrappers/test_record_video.py"
    "tests/wrappers/test_video_recorder.py"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A standard API for reinforcement learning and a diverse set of reference environments (formerly Gym)";
    homepage = "https://github.com/Farama-Foundation/Gymnasium";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
