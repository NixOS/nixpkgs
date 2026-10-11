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
      aarch64-darwin = "darwin_arm64";
    }
    .${system} or throwSystem;

  hash =
    {
      x86_64-linux = "sha256-y6ChxQxtiOYEyIgQZ1LLRtojGEh10SHQJqhMq0xNuv0=";
      aarch64-linux = "sha256-86HC7JoWyLyO5zKyATlSZW4elkNfyg5H4nLg2lfM17k=";
      armv7l-linux = "sha256-47DxeXwTnOypgqLrcfAVo6JXKepJ3CaNcPyj7hLoIBY=";
      aarch64-darwin = "sha256-hSAKeVELgx8B0GtljKEfE8mueKE78Fe3ABhhHkYy1lU=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "2.0.7";

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
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
