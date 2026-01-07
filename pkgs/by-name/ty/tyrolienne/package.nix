{
  lib,
  rustPlatform,
  copyDesktopItems,
  fetchFromGitea,
  ffmpeg,
  imagemagick,
  libadwaita,
  makeDesktopItem,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
  zenity,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tyrolienne";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "git.uku3lig.net";
    owner = "uku";
    repo = "tyrolienne";
    tag = finalAttrs.version;
    hash = "sha256-jl1h7L+Ae28A7YFoIsQqxbx2XmxxjUHebD5Xba0cB5o=";
  };

  cargoHash = "sha256-J/gS8tyy+5ZG1xl4NrYCU26lD0yvsVyRUoOXntCgVSE=";

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  # Tests are disabled because there are none, avoids having to recompile everything twice
  doCheck = false;

  postInstall = ''
    for size in 16 32 48 128 256; do
      dir="$out/share/icons/hicolor/''${size}x''${size}/apps"
      mkdir -p "$dir"
      magick data/icons/tyrolienne.png -resize ''${size}x "$dir/net.uku3lig.tyrolienne.png"
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          zenity
        ]
      }
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "net.uku3lig.tyrolienne";
      desktopName = "Tyrolienne";
      type = "Application";
      comment = "Compresses and uploads videos to Zipline";
      exec = "tyrolienne";
      icon = "net.uku3lig.tyrolienne";
      terminal = false;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple tool to convert, upload, and embed videos to Zipline";
    homepage = "https://git.uku3lig.net/uku/tyrolienne";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ uku3lig ];
    mainProgram = "tyrolienne";
  };
})
