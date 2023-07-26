{ buildPythonPackage
, onnxruntime-native
, piper-phonemize-native
, pybind11
, setuptools
}:

buildPythonPackage {
  inherit (piper-phonemize-native) pname version src;
  format = "pyproject";

  nativeBuildInputs = [
    pybind11
    setuptools
  ];

  buildInputs = [
    onnxruntime-native
    piper-phonemize-native
    piper-phonemize-native.espeak-ng
  ];

  pythonImportsCheck = [
    "piper_phonemize"
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "Phonemization libary used by Piper text to speech system";
    inherit (piper-phonemize-native.meta) homepage license maintainers;
  };
}
