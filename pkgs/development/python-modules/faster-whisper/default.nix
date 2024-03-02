{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, av
, ctranslate2
, huggingface-hub
, onnxruntime
, tokenizers

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "faster-whisper";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SYSTRAN";
    repo = "faster-whisper";
    rev = "refs/tags/v${version}";
    hash = "sha256-b8P9fI32ubOrdayA0vnjLhpZ4qffB6W+8TEOA1YLKqo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    av
    ctranslate2
    huggingface-hub
    onnxruntime
    tokenizers
  ];

  pythonImportsCheck = [
    "faster_whisper"
  ];

  # all tests require downloads
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    changelog = "https://github.com/guillaumekln/faster-whisper/releases/tag/${version}";
    description = "Faster Whisper transcription with CTranslate2";
    homepage = "https://github.com/guillaumekln/faster-whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
