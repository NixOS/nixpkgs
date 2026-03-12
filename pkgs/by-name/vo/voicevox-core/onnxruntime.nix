{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox-onnxruntime";
  version = "1.17.3";

  src = finalAttrs.passthru.sources.${stdenv.hostPlatform.system};

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r ./lib "$out/lib"

    runHook postInstall
  '';

  passthru.sources =
    let
      # Note: Only the prebuilt binaries are able to decrypt the encrypted voice models
      fetchArtifact =
        { id, hash }:
        fetchurl {
          url = "https://github.com/VOICEVOX/onnxruntime-builder/releases/download/voicevox_onnxruntime-${finalAttrs.version}/voicevox_onnxruntime-${id}-${finalAttrs.version}.tgz";
          inherit hash;
        };
    in
    {
      "x86_64-linux" = fetchArtifact {
        id = "linux-x64";
        hash = "sha256-crUof91I3IM6mSn26eOCbnk7VM4SAhgb6T9jgjoiL1g=";
      };
      "aarch64-linux" = fetchArtifact {
        id = "linux-arm64";
        hash = "sha256-J27twAe2lDJPWbw1ws+QQXJOt4ZghDemSfCW7eo5Q6k=";
      };
      "x86_64-darwin" = fetchArtifact {
        id = "osx-x86_64";
        hash = "sha256-We3IYCUtu39kzC63K9SykEpt98NfM9yAgkNbnxWlBd8=";
      };
      "aarch64-darwin" = fetchArtifact {
        id = "osx-arm64";
        hash = "sha256-ltfqGSigoVSFSS03YhOH31D0CnkuKmgX1N9z7NGFcfI=";
      };
    };

  meta = {
    license = with lib.licenses; [
      mit
      {
        name = "VOICEVOX ONNX Runtime Terms of Use";
        url = "https://github.com/VOICEVOX/voicevox_resource/blob/main/onnxruntime/README.md";
        free = false;
        redistributable = true;
      }
    ];
    maintainers = with lib.maintainers; [
      tomasajt
      eljamm
    ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
