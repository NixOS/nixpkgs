{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  pybind11,
  setuptools,

  # buildInputs
  SDL2,
  opencv,
  zlib,

  # dependencies
  importlib-resources,
  numpy,
  typing-extensions,
  jax,

  # tests
  gymnasium,
  opencv-python,
  pytestCheckHook,

  # Whether to enable recently added vector environments:
  # https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/v0.11.0/docs/vector-environment.md
  # FIXME: Disabled by default as it mysteriously causes stable-baselines3's tests to hang indefinitely.
  withVectorEnv ? false,
}:

buildPythonPackage rec {
  pname = "ale-py";
  version = "0.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Arcade-Learning-Environment";
    tag = "v${version}";
    hash = "sha256-4IkjW8HX21uBEHFtb3qETxco6FfDMgLbG1BDHWwvn58=";
  };

  build-system = [
    cmake
    ninja
    pybind11
    setuptools
  ];

  buildInputs = [
    SDL2
    zlib
  ]
  ++ lib.optionals withVectorEnv [
    opencv
  ];

  dependencies = [
    gymnasium
    importlib-resources
    numpy
    typing-extensions
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    jax
  ];

  postPatch =
    # Relax the pybind11 version
    ''
      substituteInPlace src/ale/python/CMakeLists.txt \
        --replace-fail \
          'find_package(pybind11 ''${PYBIND11_VER} QUIET)' \
          'find_package(pybind11 QUIET)'
    ''
    + lib.optionalString (!withVectorEnv) ''
      substituteInPlace setup.py \
        --replace-fail \
          "-DBUILD_VECTOR_LIB=ON" \
          "-DBUILD_VECTOR_LIB=OFF"
    '';

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "ale_py" ];

  doCheck = false;

  nativeCheckInputs = [
    gymnasium
    pytestCheckHook
  ]
  + lib.optionals withVectorEnv [
    opencv-python
  ];

  disabledTests = [
    # Fatal Python error: Aborted
    # line 414 in test_display_screen
    "test_display_screen"

    # test_atari_env.py tests fail on the majority of the environments because the ROM are missing.
    # The user is expected to manually download the roms:
    # https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/v0.9.0/docs/faq.md#i-downloaded-ale-and-i-installed-it-successfully-but-i-cannot-find-any-rom-file-at-roms-do-i-have-to-get-them-somewhere-else
    "test_check_env"
    "test_reset_step_shapes"
    "test_rollout_consistency"
    "test_sound_obs"
  ];

  meta = {
    description = "Simple framework that allows researchers and hobbyists to develop AI agents for Atari 2600 games";
    mainProgram = "ale-import-roms";
    homepage = "https://github.com/mgbellemare/Arcade-Learning-Environment";
    changelog = "https://github.com/Farama-Foundation/Arcade-Learning-Environment/releases/tag/v${version}";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ billhuang ];
    badPlatforms = [
      # FAILED: src/ale/libale.a
      # /bin/sh: CMAKE_CXX_COMPILER_AR-NOTFOUND: command not found
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
