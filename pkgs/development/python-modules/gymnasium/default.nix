{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  cloudpickle,
  gym-notices,
  jax-jumpy,
  typing-extensions,
  farama-notifications,
  importlib-metadata,
  pythonOlder,
  ffmpeg,
  jax,
  jaxlib,
  matplotlib,
  moviepy,
  opencv4,
  pybox2d,
  pygame,
  pytestCheckHook,
  scipy,
  stdenv,
}:

buildPythonPackage rec {
  pname = "gymnasium";
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
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "gymnasium" ];

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

  # if `doCheck = true` on Darwin, `jaxlib` is evaluated, which is both
  # marked as broken and throws an error during evaluation if the package is evaluated anyway.
  # disabling checks on Darwin avoids this and allows the package to be built.
  # if jaxlib is ever fixed on Darwin, remove this.
  doCheck = !stdenv.isDarwin;

  disabledTestPaths = [
    # mujoco is required for those tests but the mujoco python bindings are not packaged in nixpkgs.
    "tests/envs/mujoco/test_mujoco_custom_env.py"

    # Those tests need to write on the filesystem which cause them to fail.
    "tests/experimental/wrappers/test_record_video.py"
    "tests/utils/test_save_video.py"
    "tests/wrappers/test_record_video.py"
    "tests/wrappers/test_video_recorder.py"
  ];

  meta = with lib; {
    description = "Standard API for reinforcement learning and a diverse set of reference environments (formerly Gym)";
    homepage = "https://github.com/Farama-Foundation/Gymnasium";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
