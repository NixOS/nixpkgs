{
  lib,
  stdenv,
  buildPythonPackage,
  cmake,
  cython,
  fetchFromGitHub,
  memory-profiler,
  ninja,
  pathspec,
  pocketsphinx,
  pytestCheckHook,
  scikit-build,
  scikit-build-core,
  sounddevice,
}:

buildPythonPackage rec {
  inherit (pocketsphinx) version src;
  pname = "pocketsphinx";
  pyproject = true;

  dontUseCmakeConfigure = true;

  env.CMAKE_ARGS = lib.cmakeBool "USE_INSTALLED_POCKETSPHINX" true;

  buildInputs = [ pocketsphinx ];

  build-system = [
    cmake
    cython
    ninja
    pathspec
    scikit-build-core
  ];

  dependencies = [ sounddevice ];

  nativeCheckInputs = [
    memory-profiler
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pocketsphinx" ];

  meta = with lib; {
    description = "Small speech recognizer";
    homepage = "https://github.com/cmusphinx/pocketsphinx";
    changelog = "https://github.com/cmusphinx/pocketsphinx/blob/v${version}/NEWS";
    license = with licenses; [
      bsd2
      bsd3
      mit
    ];
    maintainers = with maintainers; [ jopejoe1 ];
  };
}
