{
  lib,
  stdenv,
  fetchzip,
  writeShellScript,
  nix-update,
  jq,
  common-updater-scripts,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux_amd64";
      aarch64-linux = "linux_arm64";
      armv7l-linux = "linux_armv7";
      x86_64-darwin = "darwin_amd64";
      aarch64-darwin = "darwin_arm64";
    }
    .${system} or throwSystem;

  hash =
    {
      x86_64-linux = "sha256-obWFWaSax4xWFLzZEPFPKtZkohqxXuQzf5lfr0CTyg0=";
      aarch64-linux = "sha256-D4FpU2dpGZa9r4lZy2RW14JP9V5S9skiu+0zMSQ165I=";
      armv7l-linux = "sha256-z58r9I0Qc/NMIZKJWGT2rjfBwPwKJ8VtYAS0woNOUkc=";
      x86_64-darwin = "sha256-A/gUS8gHSS8jWneXUNGQ9IYJYkHWEvCsb/Bre4w3jBY=";
      aarch64-darwin = "sha256-WqfG0sEKtJQscKbrrl7/6aktFzDCSogZt0lOH2o6jso=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "2.0.2";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_${plat}.tar.gz";
    stripRoot = false;
    inherit hash;
  };

  installPhase = ''
    runHook preInstall

    install -D --mode=0755 zrok2 $out/bin/zrok
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --set-interpreter "$(< "$NIX_CC/nix-support/dynamic-linker")" "$out/bin/zrok"
    ''}

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-script" ''
    ${lib.getExe nix-update} $UPDATE_NIX_ATTR_PATH --system x86_64-linux
    latestVersion=$(nix eval --raw --file . $UPDATE_NIX_ATTR_PATH.version)
    if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
      exit 0
    fi
    systems=$(nix eval --json -f . $UPDATE_NIX_ATTR_PATH.meta.platforms | ${lib.getExe jq} --raw-output '.[]')
    for system in $systems; do
      hash=$(nix store prefetch-file --unpack --json $(nix eval --raw --file . $UPDATE_NIX_ATTR_PATH.src.url --system "$system") | ${lib.getExe jq} --raw-output .hash)
      ${lib.getExe' common-updater-scripts "update-source-version"} $UPDATE_NIX_ATTR_PATH $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
    done
  '';

  meta = {
    description = "Geo-scale, next-generation sharing platform built on top of OpenZiti";
    homepage = "https://zrok.io";
    license = lib.licenses.asl20;
    mainProgram = "zrok";
    maintainers = [ lib.maintainers.bandresen ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
