{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  SDL2,
  makeWrapper,
  makeDesktopItem,
}:

let
  desktopFile = makeDesktopItem {
    name = "system-syzygy";
    exec = "@out@/bin/syzygy";
    comment = "A puzzle game";
    desktopName = "System Syzygy";
    categories = [ "Game" ];
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "system-syzygy";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "mdsteele";
    repo = "syzygy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wxe9+r3tWRXiznvjvxsmTgUC7YVKgbt+I3Q8A/WtcN0=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ SDL2 ];

  cargoHash = "sha256-H/iG6vsmtpBGYBBqNQG5EpyZaUtfXfVaHv4fkxwqrD0=";

  postInstall = ''
    mkdir -p $out/share/syzygy/
    cp -r ${finalAttrs.src}/data/* $out/share/syzygy/
    wrapProgram $out/bin/syzygy --set SYZYGY_DATA_DIR $out/share/syzygy
    mkdir -p $out/share/applications
    substituteAll ${desktopFile}/share/applications/system-syzygy.desktop $out/share/applications/system-syzygy.desktop
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Story and a puzzle game, where you solve a variety of puzzle";
    mainProgram = "syzygy";
    homepage = "https://mdsteele.games/syzygy";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.marius851000 ];
  };
})
