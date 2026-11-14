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
      x86_64-linux = "sha256-Dcm00Ar3o8FSG2vW8dFG7e3v3r2tw8o6L7HkgCzzrXs=";
      aarch64-linux = "sha256-bQbsRiISj7oaOU34MpLlqE72g0mYXopThHRH7UhNpnU=";
      armv7l-linux = "sha256-JuNYcXe7fi1i/S1MtM4Kx96FYG1xuMNAljB/MguEBVQ=";
      aarch64-darwin = "sha256-XrlFAMjtT9ibP+Nv0fN5N1CGpElMjhdQxppvwxuvG04=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "2.0.9";

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
