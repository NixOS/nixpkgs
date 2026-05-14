{
  lib,
  stdenv,
  python3,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "whisper-ctranslate2";
  version = "0.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Softcatala";
    repo = "whisper-ctranslate2";
    tag = finalAttrs.version;
    hash = "sha256-fbdvbmrZWQoqri6iZMDbElXX/sfv6gu0NDjglviLxO4=";
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
  # Tests fail in build sandbox on aarch64-linux, but the program still works at
  # runtime. See https://github.com/microsoft/onnxruntime/issues/10038.
  doCheck = with stdenv.buildPlatform; !(isAarch && isLinux);

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Whisper command line client compatible with original OpenAI client based on CTranslate2";
    homepage = "https://github.com/Softcatala/whisper-ctranslate2";
    changelog = "https://github.com/Softcatala/whisper-ctranslate2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "whisper-ctranslate2";
  };
})
