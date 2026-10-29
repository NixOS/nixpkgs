{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  av,
  ctranslate2,
  huggingface-hub,
  onnxruntime,
  tokenizers,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "faster-whisper";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SYSTRAN";
    repo = "faster-whisper";
    tag = "v${version}";
    hash = "sha256-pWVYxC1h0kIhhBxAt9oT2USuvoarlcwwYmaLUJlZZwY=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/SYSTRAN/faster-whisper/commit/2ce7f9d7a9fbe315a5804a33bf7224d42e101174.patch";
      hash = "sha256-+TEilM56PcOS+P3i9+KnG8Hnngljywb+E44gMaCys+A=";
    })
  ];

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "av"
    "tokenizers"
  ];

  dependencies = [
    av
    ctranslate2
    huggingface-hub
    onnxruntime
    tokenizers
  ];

  pythonImportsCheck = [ "faster_whisper" ];

  # all tests require downloads
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    changelog = "https://github.com/SYSTRAN/faster-whisper/releases/tag/${src.tag}";
    description = "Faster Whisper transcription with CTranslate2";
    homepage = "https://github.com/SYSTRAN/faster-whisper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
