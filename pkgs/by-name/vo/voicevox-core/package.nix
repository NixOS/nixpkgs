{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox-core";
  version = "0.15.8";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 libonnxruntime.* libvoicevox_core.* -t $out/lib
    install -Dm644 model/* -t $out/lib/model
    install -Dm644 *.h -t $out/include
    install -Dm644 README.txt -t $out/share/doc/voicevox-core

    runHook postInstall
  '';

  # When updating, run the following command to fetch all FODs:
  # nix-build -A voicevox-core.sources --keep-going
  passthru.sources =
    let
      # Note: Only the prebuilt binaries are able to decrypt the encrypted voice models
      fetchCoreArtifact =
        { id, hash }:
        fetchurl {
          url = "https://github.com/VOICEVOX/voicevox_core/releases/download/${finalAttrs.version}/voicevox_core-${id}-cpu-${finalAttrs.version}.zip";
          inherit hash;
        };
    in
    {
      "x86_64-linux" = fetchCoreArtifact {
        id = "linux-x64";
        hash = "sha256-n0rYSMR5wgjAtlQ4DWRAhJW/VevGG/Mmj6lXieG1U78=";
      };
      "aarch64-linux" = fetchCoreArtifact {
        id = "linux-arm64";
        hash = "sha256-GOgBH0UinZMiNszTp2CWJKT9prTi84KH3V9fxpmweeU=";
      };
      "x86_64-darwin" = fetchCoreArtifact {
        id = "osx-x64";
        hash = "sha256-8TRlu1ztPciKDX9Igr0TKcyLzP8WRwTN9F11MjXNNW8=";
      };
      "aarch64-darwin" = fetchCoreArtifact {
        id = "osx-arm64";
        hash = "sha256-6Na7LBZg2bWaX1VN6r6zdyg0mszBNn0e7u+cmqKVuY0=";
      };
    };

  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox_core/releases/tag/${finalAttrs.version}";
    description = "Core library for the VOICEVOX speech synthesis software";
    homepage = "https://github.com/VOICEVOX/voicevox_core";
    license = with lib.licenses; [
      mit
      ({
        name = "VOICEVOX Core Library Terms of Use";
        url = "https://github.com/VOICEVOX/voicevox_resource/blob/main/core/README.md";
        free = false;
        redistributable = true;
      })
    ];
    maintainers = with lib.maintainers; [
      tomasajt
      eljamm
    ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
