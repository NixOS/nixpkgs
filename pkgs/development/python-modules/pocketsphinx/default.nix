{
  lib,
  buildPythonPackage,
  cmake,
  cython,
  memory-profiler,
  ninja,
  pathspec,
  pocketsphinx,
  pytestCheckHook,
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

<<<<<<< HEAD
  meta = {
    description = "Small speech recognizer";
    homepage = "https://github.com/cmusphinx/pocketsphinx";
    changelog = "https://github.com/cmusphinx/pocketsphinx/blob/v${version}/NEWS";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Small speech recognizer";
    homepage = "https://github.com/cmusphinx/pocketsphinx";
    changelog = "https://github.com/cmusphinx/pocketsphinx/blob/v${version}/NEWS";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bsd2
      bsd3
      mit
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ jopejoe1 ];
=======
    maintainers = with maintainers; [ jopejoe1 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
