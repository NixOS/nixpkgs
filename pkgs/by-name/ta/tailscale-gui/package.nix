{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  pbzx,
  writeShellApplication,
  cacert,
  curl,
  jq,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tailscale-gui";
  version = "1.98.5";

  src = fetchurl {
    url = "https://pkgs.tailscale.com/stable/Tailscale-${finalAttrs.version}-macos.pkg";
    hash = "sha256-r7e8aKNWaX1psI0a3sohTUv8xmUv8oebH/ndjeHLoVA=";
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

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "tailscale-gui-update-script";
    runtimeInputs = [
      cacert
      curl
      jq
      common-updater-scripts
    ];
    text = ''
      version=$(curl --silent "https://pkgs.tailscale.com/stable/?mode=json&os=darwin" | jq -r '.MacZipsVersion')
      update-source-version tailscale-gui "$version"
    '';
  });

  meta = {
    description = "Tailscale GUI client for macOS";
    homepage = "https://tailscale.com";
    changelog = "https://tailscale.com/changelog#client";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      anish
      Br1ght0ne
    ];
    platforms = lib.platforms.darwin;
  };
})
