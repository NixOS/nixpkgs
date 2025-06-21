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
      x86_64-linux = "sha256-Ewez2QUsIAmxyjxR8wvt7UJpXVHjIb8s6gGF1YNgrec=";
      aarch64-linux = "sha256-5hZaOqnTYWeUJXGObzUZMqE62ZgNvJ9Wi8shVng10l8=";
      armv7l-linux = "sha256-MOM0OS2/mhYaxowsBVnZH0poR+wXsbjsJKldU/nAfjU=";
      x86_64-darwin = "sha256-DlB24u4CPK5NqrX+vlDJWqjtcz04X0UQurYY0hZtZ0Q=";
      aarch64-darwin = "sha256-HS7xMpJUFm2PYEe4aXMJ5THGklDTAuziCtcCgf7sX9Q=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "1.0.4";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_${plat}.tar.gz";
    stripRoot = false;
    inherit hash;
  };

  updateScript = ./update.sh;

  installPhase =
    let
      interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
    in
    ''
      runHook preInstall

      mkdir -p $out/bin
      cp zrok $out/bin/
      chmod +x $out/bin/zrok
      patchelf --set-interpreter "${interpreter}" "$out/bin/zrok"

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
