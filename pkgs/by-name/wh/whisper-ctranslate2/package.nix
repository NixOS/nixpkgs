{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:
let
  pname = "whisper-ctranslate2";
  version = "0.5.1";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Softcatala";
    repo = "whisper-ctranslate2";
    tag = version;
    hash = "sha256-y1xCycWUxrLwmnk6tlyag0uN0oo6DRQFeIIBw555VjY=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    ctranslate2
    faster-whisper
    numpy
    pyannote-audio
    sounddevice
    tqdm
  ];

  nativeCheckInputs = with python3Packages; [
    nose2
  ];

  checkPhase = ''
    runHook preCheck
    # Note: we are not running the `e2e-tests` because they require downloading models from the internet.
    ${python3.interpreter} -m nose2 -s tests
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Whisper command line client compatible with original OpenAI client based on CTranslate2";
    homepage = "https://github.com/Softcatala/whisper-ctranslate2";
    changelog = "https://github.com/Softcatala/whisper-ctranslate2/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "whisper-ctranslate2";
  };
}
