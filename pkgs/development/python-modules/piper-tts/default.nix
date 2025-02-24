{
  piper-tts-native,
  lib,
  buildPythonPackage,
  piper-phonemize,
  onnxruntime,
}:
buildPythonPackage rec {
  inherit (piper-tts-native) pname version src;
  sourceRoot = "source/src/python_run";

  propagatedBuildInputs = [
    piper-phonemize
    onnxruntime
  ];

  pythonImportsCheck = [
    "piper"
  ];

  meta = {
    mainProgram = "piper";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Python component for piper-tts";
    inherit (piper-tts-native.meta) homepage license;
  };
}
