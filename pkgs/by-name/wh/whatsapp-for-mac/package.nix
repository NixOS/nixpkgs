{
  lib,
  fetchzip,
  stdenvNoCC,
  writeShellApplication,
  curl,
  xmlstarlet,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "whatsapp-for-mac";
  version = "2.24.11.85";

  src = fetchzip {
    extension = "zip";
    name = "WhatsApp.app";
    url = "https://web.whatsapp.com/desktop/mac_native/release/?version=${finalAttrs.version}&extension=zip&configuration=Release&branch=relbranch";
    hash = "sha256-vbgym7AfRi6kzZVMPRA6lP+6pL8cXnR7yt9hWPnt3+E=";
  };

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "whatsapp-update-script";
    runtimeInputs = [
      curl
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      url=$(curl --silent "https://web.whatsapp.com/desktop/mac_native/updates/?branch=relbranch&configuration=Release")
      version=$(echo "$url" | xmlstarlet sel -t -v "substring-before(substring-after(//enclosure/@url, 'version='), '&')")
      update-source-version whatsapp-for-mac "$version" --file=./pkgs/by-name/wh/whatsapp-for-mac/package.nix
    '';
  });

  meta = {
    description = "Native desktop client for WhatsApp";
    homepage = "https://www.whatsapp.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iivusly ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
