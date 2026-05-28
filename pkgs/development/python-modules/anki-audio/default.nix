{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  stdenv,
  hatchling,
  mpv-unwrapped,
  lame,
}:

buildPythonPackage (finalAttrs: {
  pname = "anki-audio";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki-bundle-extras";
    rev = "e83c6e64dcb110ed579fc78afbb4e72bed8fb9e9";
    hash = "sha256-iOAZ7EytEVpvsrnVFk6bkiU8FWf2Q7tTzJjawZQCW6E=";
  };

  build-system = [ hatchling ];

  env = {
    ANKI_AUDIO_TARGET_OS = "darwin";
    ANKI_AUDIO_TARGET_ARCH = stdenv.hostPlatform.darwinArch;
  };

  preBuild =
    let
      archDir = if stdenv.hostPlatform.isAarch64 then "arm64" else "amd64";
    in
    ''
      mkdir -p mac/${archDir}/dist/audio/Resources
      ln -s ${lib.getExe mpv-unwrapped} ${lib.getExe lame} mac/${archDir}/dist/audio/Resources/
    '';

  pythonImportsCheck = [ "anki_audio" ];

  meta = {
    description = "Audio binaries (mpv, lame) for Anki";
    homepage = "https://github.com/ankitects/anki-bundle-extras";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.darwin;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      euank
      junestepp
      oxij
    ];
  };
})
