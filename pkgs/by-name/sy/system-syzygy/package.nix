{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  SDL2,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "system-syzygy";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "mdsteele";
    repo = "syzygy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wxe9+r3tWRXiznvjvxsmTgUC7YVKgbt+I3Q8A/WtcN0=";
  };

  # nixpkgs SDL2 uses pkg-config, not the macOS SDL2 framework.
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail \
        'features = ["unsafe_textures", "use_mac_framework"]' \
        'features = ["unsafe_textures"]'
  '';

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [ SDL2 ];

  cargoHash = "sha256-H/iG6vsmtpBGYBBqNQG5EpyZaUtfXfVaHv4fkxwqrD0=";

  desktopItems = [
    (makeDesktopItem {
      name = "system-syzygy";
      exec = "syzygy";
      icon = "syzygy";
      comment = "A narrative meta-puzzle game";
      desktopName = "System Syzygy";
      categories = [ "Game" ];
    })
  ];

  postInstall = ''
    hicolor="$out/share/icons/hicolor"
    mkdir -p $out/share/syzygy/
    cp -r ${finalAttrs.src}/data/* $out/share/syzygy/
    wrapProgram $out/bin/syzygy --set SYZYGY_DATA_DIR $out/share/syzygy

    for res in 128x128 32x32 512x512; do
      install -Dm644 data/icon/$res.png \
        "$hicolor/$res/apps/syzygy.png"
    done

    install -Dm644 data/icon/512x512@2x.png \
      "$hicolor/512x512@2/apps/syzygy.png"
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Narrative meta-puzzle game in the style of The Fool's Errand";
    longDescription = ''
      System Syzygy is a story and a puzzle game, in the style of Cliff
      Johnson's The Fool's Errand and 3 in Three, and of Andrew Plotkin's
      System's Twilight.  By the end of the game, all the different puzzles and
      pieces of the story come together into a single meta-puzzle.
    '';
    mainProgram = "syzygy";
    homepage = "https://mdsteele.games/syzygy";
    changelog = "https://github.com/mdsteele/syzygy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.marius851000 ];
  };
})
