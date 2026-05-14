{
  lib,
  stdenv,
  buildPythonPackage,
  espeak-ng,
  onnxruntime-native,
  piper-phonemize-native,
  pybind11,
  setuptools,
}:

buildPythonPackage {
  inherit (piper-phonemize-native) pname version src;
  pyproject = true;

  nativeBuildInputs = [
    pybind11
    setuptools
  ];

  buildInputs = [
    espeak-ng
    onnxruntime-native
    piper-phonemize-native
  ];

  # coredump in onnxruntime::logging::Logger& onnxruntime::logging::LoggingManager::DefaultLogger()
  pythonImportsCheck = lib.optionals stdenv.hostPlatform.isx86 [ "piper_phonemize" ];

  # no tests
  doCheck = false;

  meta = {
    # dylib import fails with no LC_RPATH's found
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86;
    description = "Phonemization libary used by Piper text to speech system";
    inherit (piper-phonemize-native.meta) homepage license maintainers;
  };
}
