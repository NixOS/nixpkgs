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
  wheel,

  # buildInputs
  SDL2,
  zlib,

  # dependencies
  importlib-resources,
  numpy,
  typing-extensions,

  # tests
  gymnasium,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ale-py";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Arcade-Learning-Environment";
    tag = "v${version}";
    hash = "sha256-CGUlQFQoQZqs+Jd3IU/o50VwX+tEHrs3KHrcVWahEpo=";
  };

  build-system = [
    cmake
    ninja
    pybind11
    setuptools
    wheel
  ];

  buildInputs = [
    SDL2
    zlib
  ];

  dependencies = [
    importlib-resources
    numpy
    typing-extensions
  ];

  postPatch =
    # Relax the pybind11 version
    ''
      substituteInPlace src/ale/python/CMakeLists.txt \
        --replace-fail 'find_package(pybind11 ''${PYBIND11_VER} QUIET)' 'find_package(pybind11 QUIET)'
    '';

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "ale_py" ];

  nativeCheckInputs = [
    gymnasium
    pytestCheckHook
  ];

  disabledTests = [
    # test_atari_env.py tests fail on the majority of the environments because the ROM are missing.
    # The user is expected to manually download the roms:
    # https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/v0.9.0/docs/faq.md#i-downloaded-ale-and-i-installed-it-successfully-but-i-cannot-find-any-rom-file-at-roms-do-i-have-to-get-them-somewhere-else
    "test_check_env"
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
      # fails to link with missing library
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
