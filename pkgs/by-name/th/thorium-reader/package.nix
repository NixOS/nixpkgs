{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  makeShellWrapper,
  makeBinaryWrapper,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
}:

buildNpmPackage (finalAttrs: {
  pname = "thorium-reader";
  version = "3.3.0";
  nodejs = nodejs_24;
  npmDepsHash = "sha256-UR2MSqmdJ79Fz7qjQRkCAwx2jdMn8KLWPzNSnnsb5Ak=";
  makeCacheWritable = true;

  src = fetchFromGitHub {
    owner = "edrlab";
    repo = "thorium-reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2d5M9C/cLK2A8O3Ls0xEkT6H8tucVR7eivPi+82V7Zg=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  # makeBinaryWrapper is required on Darwin since MacOS is confuses itself
  # into thinking it needs Rosetta 2 if it encounters a non-MachO executable
  # in a .app bundle.
  # Simultaneously, we need makeShellWrapper on linux platforms to pass
  # electron-specific flags.
  nativeBuildInputs = [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    makeShellWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    desktopToDarwinBundle
  ];

  postInstall =
    let
      ozoneFlags = lib.optionalString stdenv.hostPlatform.isLinux ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"'';
    in
    ''
      install -Dpm644 resources/icon.png $out/share/icons/thorium-reader.png

      cp -r dist/* $out/lib/node_modules/EDRLab.ThoriumReader/

      ${
        if stdenv.hostPlatform.isDarwin then "makeBinaryWrapper" else "makeWrapper"
      } '${lib.getExe electron}' "$out/bin/thorium-reader" \
        --add-flags $out/lib/node_modules/EDRLab.ThoriumReader \
        ${ozoneFlags} \
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
    maintainers = with lib.maintainers; [
      YodaDaCoda
      agarmu
    ];
    platforms = lib.platforms.all;
    mainProgram = "thorium-reader";
  };
})
