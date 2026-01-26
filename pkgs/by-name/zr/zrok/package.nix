{
  lib,
  stdenv,
  fetchzip,
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
      x86_64-linux = "sha256-ytksYeWHLWrNeeTW0aCBw+dc0N7WtLtNpqRZ10Y3WbA=";
      aarch64-linux = "sha256-HbO+IjAiccbyquWrvXrCFRkYKlbvJ2wlk49ydGDbGbs=";
      armv7l-linux = "sha256-mvZz4MCe9IGdfjfFbrNhmjAidPB8e7IeOLATclTKdcw=";
      x86_64-darwin = "sha256-mDEn3rnE7FBDlGqrd3pmOL4mplOf7WpGi4A1W1UqVok=";
      aarch64-darwin = "sha256-yxL9zJDRWrkmizEZ5Da0Lo1YBJEBOJinsOKpOrMKMlY=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "2.0.0-rc4";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_${plat}.tar.gz";
    stripRoot = false;
    inherit hash;
  };

  passthru.updateScript = ./update.sh;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp zrok $out/bin/
    chmod +x $out/bin/zrok
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --set-interpreter "$(< "$NIX_CC/nix-support/dynamic-linker")" "$out/bin/zrok"
    ''}

    runHook postInstall
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
