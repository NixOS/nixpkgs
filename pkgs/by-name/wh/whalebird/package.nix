{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron_37,
  yarn-berry,
  writableTmpDirAsHomeHook,
}:

let
  electron = electron_37;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "whalebird";
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "h3poteto";
    repo = "whalebird-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0wXfyRmCDkirYgSXUuvrIkQ2yRnVRWMoyyqifIF5VU4=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-vwSVd+ttQFeXEsRsh9jmHKouyqkHeosy0Z/LMb4pzeI=";
  };

  postPatch = ''
    sed -i "/module.exports = {/a \  typescript: {\n    ignoreBuildErrors: true,\n  }," renderer/next.config.js
  '';

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    yarn-berry
    yarn-berry.yarnBerryConfigHook
    writableTmpDirAsHomeHook
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Whalebird";
      comment = finalAttrs.meta.description;
      categories = [ "Network" ];
      exec = "whalebird";
      icon = "whalebird";
      name = "whalebird";
    })
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    yarn exec nextron build --no-pack
    yarn exec electron-builder --dir \
      --linux \
      -p never \
      --config electron-builder.yml \
      -c.electronDist="${electron.dist}" \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -r ./dist/*-unpacked $out/opt/Whalebird
  ''
  # Install icons
  # Taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=whalebird#n41
  + ''
    for i in 16 32 128 256 512; do
      install -Dm644 "resources/icons/icon.iconset/icon_$i"x"$i.png" \
        "$out/share/icons/hicolor/$i"x"$i/apps/whalebird.png"
    done
    install -Dm644 "resources/icons/icon.iconset/icon_32x32@2x.png" \
      "$out/share/icons/hicolor/64x64/apps/whalebird.png"

    makeWrapper "${electron}/bin/electron" "$out/bin/whalebird" \
      --add-flags "$out/opt/Whalebird/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}"

    runHook postInstall
  '';

  meta = {
    description = "Single-column Fediverse client for desktop";
    mainProgram = "whalebird";
    homepage = "https://whalebird.social";
    changelog = "https://github.com/h3poteto/whalebird-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ weathercold ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
