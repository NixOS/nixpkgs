{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SYSTRAN";
    repo = "faster-whisper";
    tag = "v${version}";
    hash = "sha256-kv2pLszImGzrPI0q2eglX//BMrj2pF0oMHnZ+7VKrHI=";
  };

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

  meta = with lib; {
    changelog = "https://github.com/SYSTRAN/faster-whisper/releases/tag/${src.tag}";
    description = "Faster Whisper transcription with CTranslate2";
    homepage = "https://github.com/SYSTRAN/faster-whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
