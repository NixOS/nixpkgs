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
  version = "unstable-2024-07-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SYSTRAN";
    repo = "faster-whisper";
    # rev = "refs/tags/v${version}";
    rev = "d57c5b40b06e59ec44240d93485a95799548af50";
    hash = "sha256-C/O+wt3dykQJmH+VsVkpQwEAdyW8goMUMKR0Z3Y7jdo=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "tokenizers"
    "av"
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
    changelog = "https://github.com/SYSTRAN/faster-whisper/releases/tag/v${version}";
    description = "Faster Whisper transcription with CTranslate2";
    homepage = "https://github.com/SYSTRAN/faster-whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
