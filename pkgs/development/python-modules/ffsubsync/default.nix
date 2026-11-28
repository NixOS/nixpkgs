{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg,

  # build-system
  setuptools,

  # dependencies
  auditok,
  chardet,
  charset-normalizer,
  faust-cchardet,
  ffmpeg-python,
  numpy,
  pysubs2,
  rich,
  six,
  srt,
  tqdm,
  typing-extensions,
  webrtcvad,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ffsubsync";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smacke";
    repo = "ffsubsync";
    tag = finalAttrs.version;
    hash = "sha256-n9bYQgbBHGRJl79EiK7pTMDCcbI4ALudZUNc2SU0Wgg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    auditok
    chardet
    charset-normalizer
    faust-cchardet
    ffmpeg-python
    numpy
    pysubs2
    rich
    setuptools
    six
    srt
    tqdm
    typing-extensions
    webrtcvad
  ];

  # webrtcvad provides the same import as upstream's wheel-only dependency.
  pythonRemoveDeps = [ "webrtcvad-wheels" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ffsubsync" ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  meta = {
    homepage = "https://github.com/smacke/ffsubsync";
    description = "Automagically synchronize subtitles with video";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      davinci42
    ];
    mainProgram = "ffsubsync";
  };
})
