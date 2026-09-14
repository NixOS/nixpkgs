{
  stdenvNoCC,
  lib,
  fetchurl,
  curl,
  common-updater-scripts,
  writeShellApplication,
  gnugrep,
  installShellFiles,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tideways-cli";
  version = "1.3.2";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform for tideways-cli: ${stdenvNoCC.hostPlatform.system}");

  installPhase = ''
    runHook preInstall

    installBin tideways

    installShellCompletion --cmd tideways \
      --bash <($out/bin/tideways completion bash) \
      --zsh <($out/bin/tideways completion zsh) \
      --fish <($out/bin/tideways completion fish)

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_linux_amd64-${finalAttrs.version}.tar.gz";
        hash = "sha256-6arHj82OD5zKY0uEzimioeuD4lRoQ99YrT/aK+S1W38=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_linux_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-qOyRCbopaiWE0YtQgF6ocIdbCUDhid3w3X7AeA3kOlI=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_macos_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-90qhY1TKhOen6+ararnVVu+cIod1luEHyC3U/z9EtJY=";
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
