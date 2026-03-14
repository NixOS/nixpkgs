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
  version = "26.8.76";

  src = fetchzip {
    extension = "zip";
    name = "WhatsApp.app";
    url = "https://web.whatsapp.com/desktop/mac_native/release/?version=2.${finalAttrs.version}&extension=zip&configuration=Release&branch=relbranch&is_buck=true";
    hash = "sha256-YPx3VpGYyCNfneaISHAezTY+wx79paCy88t0APE1EGc=";
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
      feed_url="https://web.whatsapp.com/desktop/mac_native/updates/?branch=relbranch&configuration=Release"
      version=$(curl --silent "$feed_url" | xmlstarlet sel -N sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" -t -v "//sparkle:shortVersionString")
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
