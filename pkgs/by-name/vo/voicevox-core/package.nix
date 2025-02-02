{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
}:

let
  platformInfoTable = {
    "x86_64-linux" = {
      id = "linux-x64";
      hash = "sha256-/PD5e0bWgnIsIrvyOypoJw30VkgbOFWV1NJpPS2G0WM=";
    };
    "aarch64-linux" = {
      id = "linux-arm64";
      hash = "sha256-zfiorXZyIISZPXPwmcdYeHceDmQXkUhsvTkNZScg648=";
    };
    "x86_64-darwin" = {
      id = "osx-x64";
      hash = "sha256-cdNdV1fVPkz6B7vtKZiPsLQGqnIiDtYa9KTcwSkjdJg=";
    };
    "aarch64-darwin" = {
      id = "osx-arm64";
      hash = "sha256-Z1dq2t/HBQulbPF23ZCihOrcZHMpTXEQ6yXKORZaFPk=";
    };
  };

  platformInfo =
    platformInfoTable.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "voicevox-core";
  version = "0.15.4";

  # Note: Only the prebuilt binaries are able to decrypt the encrypted voice models
  src = fetchzip {
    url = "https://github.com/VOICEVOX/voicevox_core/releases/download/${finalAttrs.version}/voicevox_core-${platformInfo.id}-cpu-${finalAttrs.version}.zip";
    inherit (platformInfo) hash;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 libonnxruntime.* libvoicevox_core.* -t $out/lib
    install -Dm644 model/* -t $out/lib/model
    install -Dm644 *.h -t $out/include
    install -Dm644 README.txt -t $out/share/doc/voicevox-core

    runHook postInstall
  '';

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
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.attrNames platformInfoTable;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
