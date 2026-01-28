{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  pbzx,
  version,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tailscale-gui";
  inherit version;

  src = fetchurl {
    url = "https://pkgs.tailscale.com/stable/Tailscale-${finalAttrs.version}-macos.pkg";
    hash = "sha256-MPS6OA6+0SN0IZjPPcV1fE6VS7BdzXZE+z5HkfoA31M=";
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
    description = "Standalone Tailscale GUI client for macOS";
    homepage = "https://tailscale.com";
    changelog = "https://tailscale.com/changelog#client";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ anish ];
    platforms = lib.platforms.darwin;
  };
})
