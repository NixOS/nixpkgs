{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ctranslate2,
  ctranslate2-cpp,
  minisbd,
  sacremoses,
  sentencepiece,
  spacy,
  stanza,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  ctranslate2OneDNN = ctranslate2.override {
    ctranslate2-cpp = ctranslate2-cpp.override {
      # https://github.com/OpenNMT/CTranslate2/issues/1294
      withOneDNN = true;
      withOpenblas = false;
    };
  };

  inherit (stdenv.hostPlatform) isLinux isAarch64;
  isAarch64Linux = isLinux && isAarch64;
in
buildPythonPackage (finalAttrs: {
  pname = "argostranslate";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "argosopentech";
    repo = "argos-translate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8uzWS0YZEteeLTYAp9qpnnJhxyhxbWkKt1krqe/RF4M=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "stanza"
  ];
  dependencies = [
    ctranslate2OneDNN
    minisbd
    sacremoses
    sentencepiece
    spacy
    stanza
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  pythonImportsCheck = lib.optionals (!isAarch64Linux) [
    "argostranslate"
    "argostranslate.translate"
  ];
  doCheck = !isAarch64Linux;

  meta = {
    description = "Open-source offline translation library written in Python";
    homepage = "https://www.argosopentech.com";
    changelog = "https://github.com/argosopentech/argos-translate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      misuzu
      Stebalien
    ];
  };
})
