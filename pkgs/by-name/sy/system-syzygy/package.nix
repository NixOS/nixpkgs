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
rustPlatform.buildRustPackage rec {
  pname = "system-syzygy";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mdsteele";
    repo = "syzygy";
    rev = "5ba148fed7aae14bf35108d7303e4194e8ffe5e8";
    sha256 = "07mzwx8ql33q865snnw4gm3dgf0mnm60lnq1f5fgas2yjy9g9vwa";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ SDL2 ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ahi-0.1.0" = "sha256-EliAObznLP1wkk8r3c3hhB300HYnEd9N6CJW+xG6bxE=";
      "itersynth-0.1.0" = "sha256-dXQ+uBFchcnOjKF/CcS+AwhzFzejk2JCvvKMfS64RRQ=";
      "sdl2-0.31.0" = "sha256-wTam0hwiajdw/ub2yM6q7+50Y3AueStcK5HLa65Y2XQ=";
      "winres-0.1.6" = "sha256-7jYrgc3BV2UmzfACc/xyYsTkaXBPfn+bLmwdrcBe1O0=";
    };
  };

  postInstall = ''
    mkdir -p $out/share/syzygy/
    cp -r ${src}/data/* $out/share/syzygy/
    wrapProgram $out/bin/syzygy --set SYZYGY_DATA_DIR $out/share/syzygy
    mkdir -p $out/share/applications
    substituteAll ${desktopFile}/share/applications/system-syzygy.desktop $out/share/applications/system-syzygy.desktop
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Story and a puzzle game, where you solve a variety of puzzle";
    mainProgram = "syzygy";
    homepage = "https://mdsteele.games/syzygy";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marius851000 ];
  };
}
