{
  stdenvNoCC,
  lib,
  fetchurl,
  curl,
  common-updater-scripts,
  writeShellApplication,
  gnugrep,
  installShellFiles,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tideways-cli";
  version = "1.2.20";

  nativeBuildInputs = [ installShellFiles ];

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform for tideways-cli: ${stdenvNoCC.hostPlatform.system}");

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp tideways $out/bin/tideways
    chmod +x $out/bin/tideways

    installShellCompletion --cmd tideways \
      --bash <($out/bin/tideways completion bash) \
      --zsh <($out/bin/tideways completion zsh) \
      --fish <($out/bin/tideways completion fish)

    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_linux_amd64-${finalAttrs.version}.tar.gz";
        hash = "sha256-nhwWsD3EefHSC7YSVla4WFTDiTWZjTf7sUZjMNROXoQ=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_linux_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-s74CnmEQ9RPki1af477tQFkrp6C9MwfehXTq2HPNAkk=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_macos_amd64-${finalAttrs.version}.tar.gz";
        hash = "sha256-hlF75uRbSqafZL6sK2Zctxxvy7VBxZQBgTI7tSugePc=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_macos_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-RTt5XKMJbYPea6pEPD72mITfUW41v584zrwT3rkEcQg=";
      };
    };

    updateScript = "${
      writeShellApplication {
        name = "update-tideways-cli";
        runtimeInputs = [
          curl
          gnugrep
          common-updater-scripts
        ];
        text = ''
          NEW_VERSION=$(curl --fail -L -s https://tideways.com/profiler/downloads | grep -E 'https://tideways.s3.amazonaws.com/cli/([0-9]+\.[0-9]+\.[0-9]+)/tideways-cli_linux_amd64-\1.tar.gz' | grep -oP 'cli/\K[0-9]+\.[0-9]+\.[0-9]+')

          if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
              echo "The new version same as the old version."
              exit 0
          fi

          for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
            update-source-version "tideways-cli" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
          done
        '';
      }
    }/bin/update-tideways-cli";
  };

  meta = {
    description = "Tideways Profiler CLI";
    homepage = "https://tideways.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "tideways";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };
})
