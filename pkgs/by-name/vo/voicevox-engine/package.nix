{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  voicevox-core,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox-engine";
  version = "0.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox_engine";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-1pEUQWhDOA7rNkFsGZsh8l6rN4vL8UTY2qhqmaUGISA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  # populate speaker_info directory with the actual model metadata
  configurePhase = ''
    runHook preConfigure

    rm -r speaker_info/*

    for dir in ${finalAttrs.passthru.resources}/character_info/*; do
        dir_name="$(basename "$dir")"
        uuid=''${dir_name#*"_"}
        cp -r --no-preserve=all "$dir" speaker_info/"$uuid"
        rm speaker_info/"$uuid"/*/*.png_large
    done

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/voicevox-engine
    cp -r voicevox_engine engine_manifest_assets speaker_info ui_template run.py engine_manifest.json presets.yaml default.csv $out/share/voicevox-engine

    makeWrapper ${finalAttrs.passthru.python.interpreter} $out/bin/voicevox-engine \
        --add-flags "$out/share/voicevox-engine/run.py" \
        --add-flags "--voicelib_dir=${voicevox-core}/lib"

    runHook postInstall
  '';

  passthru = {
    resources = fetchFromGitHub {
      owner = "VOICEVOX";
      repo = "voicevox_resource";
      rev = "refs/tags/${finalAttrs.version}";
      hash = "sha256-xLuTOSZmzCZbQADC3KKOftpuY1DPS+zir7z5mzbWhBg=";
    };

    pyopenjtalk = python3.pkgs.callPackage ./pyopenjtalk.nix { };

    python = python3.withPackages (
      ps: with ps; [
        setuptools
        python
        numpy
        (fastapi.override { pydantic = pydantic_1; })
        python-multipart
        uvicorn
        soundfile
        pyyaml
        pyworld
        jinja2
        finalAttrs.passthru.pyopenjtalk
        semver
        platformdirs
        soxr
        pydantic_1
        starlette
      ]
    );
  };

  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox_engine/releases/tag/${finalAttrs.version}";
    description = "Engine for the VOICEVOX speech synthesis software";
    homepage = "https://github.com/VOICEVOX/voicevox_engine";
    license = lib.licenses.lgpl3Only;
    mainProgram = "voicevox-engine";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
