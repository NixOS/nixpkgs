{ lib
, python3
, makeWrapper
, stdenv
, fetchFromGitHub
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    faster-whisper
    requests
    numpy
    sounddevice
    pynput
    pyperclip
  ] ++ lib.optionals stdenv.isLinux [
    evdev
    scipy
  ]);

in stdenv.mkDerivation (finalAttrs: {
  pname   = "whisper-dictate";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "FactusConsulting";
    repo  = "whisper-dictate";
    rev   = "v${finalAttrs.version}";
    hash  = "sha256-Y93fRQNO+VCc+GXltV672r0zdFuOJkN2zRpslSx7Q/4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 voice_pi.py $out/lib/whisper-dictate/voice_pi.py

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/whisper-dictate \
      --add-flags "$out/lib/whisper-dictate/voice_pi.py" \
      --set VOICEPI_SKIP_SYSCHECK 1

    runHook postInstall
  '';

  meta = {
    description  = "Local push-to-talk dictation using Whisper STT";
    longDescription = ''
      App-agnostic push-to-talk dictation. Hold a key, speak quietly but clearly,
      release — the transcribed text is injected into whatever window has focus.
      Whisper runs fully locally on your own machine; nothing leaves the box.
    '';
    homepage     = "https://github.com/FactusConsulting/whisper-dictate";
    changelog    = "https://github.com/FactusConsulting/whisper-dictate/releases/tag/v${finalAttrs.version}";
    license      = lib.licenses.mit;
    maintainers  = with lib.maintainers; [ ];
    platforms    = lib.platforms.unix;
    mainProgram  = "whisper-dictate";
  };
})
