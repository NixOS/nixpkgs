{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  makeWrapper,
  electron,
  copyDesktopItems,
  makeDesktopItem,
}:

buildNpmPackage (finalAttrs: {
  pname = "thorium-reader";
  version = "3.2.2";
  nodejs = nodejs_24;
  npmDepsHash = "sha256-T70Oxn97oDyFSxkJ55nlM2ET0UEWpo8ahnipkUwgTcM=";
  makeCacheWritable = true;

  src = fetchFromGitHub {
    owner = "edrlab";
    repo = "thorium-reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+1cc8UxcLaqC6Yrc4RYAKDZ4hzoz0eX31HaiUtp/znE=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  postInstall = ''
    install -Dpm644 resources/icon.png $out/share/icons/hicolor/1024x1024/apps/thorium-reader.png

    cp -r dist/* $out/lib/node_modules/EDRLab.ThoriumReader/

    makeWrapper '${lib.getExe electron}' "$out/bin/thorium-reader" \
      --add-flags $out/lib/node_modules/EDRLab.ThoriumReader \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "thorium-reader";
      desktopName = "Thorium";
      exec = "thorium-reader %u";
      terminal = false;
      type = "Application";
      icon = "thorium-reader";
      startupWMClass = "thorium-reader";
      mimeTypes = [
        "application/epub+zip"
        "application/daisy+zip"
        "application/vnd.readium.lcp.license.v1.0+json"
        "application/audiobook+zip"
        "application/webpub+zip"
        "application/audiobook+lcp"
        "application/pdf+lcp"
        "x-scheme-handler/thorium"
        "x-scheme-handler/opds"
      ];
      comment = "Desktop application to read ebooks";
      categories = [ "Office" ];
    })
  ];

  meta = {
    description = "EPUB reader";
    homepage = "https://www.edrlab.org/software/thorium-reader/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ YodaDaCoda ];
    platforms = lib.platforms.all;
    mainProgram = "thorium-reader";
  };
})
