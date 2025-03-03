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
  version = "1.2.6";

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
        hash = "sha256-sKa+MgbzdudDCMYOHjzBebhQsxQ79qWDx855uWbbo3Y=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_linux_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-BDtut3oJI9dmIL77R4BhGVnEJrMj0TVdNUNkO7kie10=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_macos_amd64-${finalAttrs.version}.tar.gz";
        hash = "sha256-AoGlyUcL0LW5QWJYQt9keqdR14HtLEX3CODgX0sFsVw=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://s3-eu-west-1.amazonaws.com/tideways/cli/${finalAttrs.version}/tideways-cli_macos_arm64-${finalAttrs.version}.tar.gz";
        hash = "sha256-3WtyT8NqJM+2gdmpxmA0ZoQcIna4Ma4bz1eyTbUSXJ0=";
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

  meta = with lib; {
    description = "Tideways Profiler CLI";
    homepage = "https://tideways.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "tideways";
    license = licenses.unfree;
    maintainers = with maintainers; [ shyim ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
  };
})
