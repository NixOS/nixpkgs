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
  version = "1.2.18";

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
        hash = "sha256-+TXQWaZ6+ahXcy8Kibh7VuqaclLglI3FJnW5qMjmuAg=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_linux_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-9/WBa6qzIc+yulPFVC6tpfdrhxCda23iLmu+Vy99HvQ=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_macos_amd64-${finalAttrs.version}.tar.gz";
        hash = "sha256-5s9FTA3lI6mrt34di80nrP/5oTH2lqz1BwFo2Pd8ErY=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_macos_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-3dwFFYk2WIqQf6sFVc4Jq1Zhgb4Tvvlj0IhQlnyJ6KA=";
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
