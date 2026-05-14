{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  pbzx,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tailscale-gui";
  version = "1.92.3";

  src = fetchurl {
    url = "https://pkgs.tailscale.com/stable/Tailscale-${finalAttrs.version}-macos.pkg";
    hash = "sha256-K5tJHyFhqnxV4KHzr7YOHRoH33vk+dq+EVWyUo88nuI=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    xar
    cpio
    pbzx
  ];

  installPhase = ''
    runHook preInstall
    xar -xf $src
    cd Distribution.pkg
    pbzx -n Payload | cpio -i

    mkdir -p $out/Applications/Tailscale.app
    mkdir -p $out/bin

    cp -R Contents $out/Applications/Tailscale.app/
    ln -s "$out/Applications/Tailscale.app/Contents/MacOS/Tailscale" "$out/bin/tailscale"

    runHook postInstall
  '';

  meta = {
    description = "Tailscale GUI client for macOS";
    homepage = "https://tailscale.com";
    changelog = "https://tailscale.com/changelog#client";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ anish ];
    platforms = lib.platforms.darwin;
  };
})
