{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  importlib-metadata,

  # checks
  gymnasium,
  pytestCheckHook,

  stdenv,
}:

buildPythonPackage rec {
  pname = "ale-py";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Arcade-Learning-Environment";
    tag = "v${version}";
    hash = "sha256-MDMCYnyLZYbQXwyr5VuPeVEop825nD++yQ7hhsW4BX8=";
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
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  # To propagate `cmakeFlags` inject `CMAKE_ARGS` into setuptools' invocation
  # of cmake. Shell variables' expansions won't be performed, use `preConfigure`
  # to prepare flags that rely on it
  patchPhase = ''
    substituteInPlace setup.py \
      --replace-fail "cmake_args = [" \
      "cmake_args = os.environ.get(\"CMAKE_ARGS\", \"\").split() + ["
  '';

  postPatch =
    # Relax the pybind11 version
    ''
      substituteInPlace src/ale/python/CMakeLists.txt \
        --replace-fail 'find_package(pybind11 ''${PYBIND11_VER} QUIET)' 'find_package(pybind11 QUIET)'
    '';

  dontUseCmakeConfigure = true;

  preConfigure = ''
    export CMAKE_ARGS=$cmakeFlags "''${cmakeFlagsArray[@]}"
  '';

  cmakeFlags = lib.optional stdenv.isDarwin [
    "-DCMAKE_CXX_COMPILER_AR=${stdenv.cc}/bin/ar"
    "-DCMAKE_CXX_COMPILER_RANLIB=${stdenv.cc}/bin/ranlib"
  ];

  pythonImportsCheck = [ "ale_py" ];

  nativeCheckInputs = [
    gymnasium
    pytestCheckHook
  ];

  # test_atari_env.py::test_check_env fails on the majority of the environments because the ROM are missing.
  # The user is expected to manually download the roms:
  # https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/v0.9.0/docs/faq.md#i-downloaded-ale-and-i-installed-it-successfully-but-i-cannot-find-any-rom-file-at-roms-do-i-have-to-get-them-somewhere-else
  disabledTests = [ "test_check_env" ];

  meta = {
    description = "Simple framework that allows researchers and hobbyists to develop AI agents for Atari 2600 games";
    mainProgram = "ale-import-roms";
    homepage = "https://github.com/mgbellemare/Arcade-Learning-Environment";
    changelog = "https://github.com/Farama-Foundation/Arcade-Learning-Environment/releases/tag/v${version}";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ billhuang ];
  };
}
