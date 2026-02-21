{
  lib,
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

  pythonRelaxDeps = [
    "stanza"
  ];

  pythonImportsCheck = [
    "argostranslate"
    "argostranslate.translate"
  ];

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
