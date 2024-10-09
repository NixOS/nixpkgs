{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  fetchurl,
  # Build depends
  cmake,
  qt6,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "tanglet";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xhFxH6yBKZwI5+5BX5F4H325h2V7hOLe7UocUMcrQAo=";
  };

  buildInputs = [
    cmake
    qt6.full
    zlib
  ];

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Tanglet";
    comment = "Single player word finding game based on Boggle";
    exec = "tanglet";
    icon = fetchurl {
      url = "https://github.com/gottcode/tanglet/raw/v${version}/icons/hicolor/64x64/apps/tanglet.png";
      hash = "sha256-K3mL/GXWKfBU0jV59P3/h6BIojICG85iltv4nrrlEq4=";
    };
    categories = [ "Game" ];
  };

  meta = with lib; {
    description = "Single player word finding game based on Boggle";
    mainProgram = "tanglet";
    longDescription = ''
      Tanglet is a single player word finding game based on Boggle. The object
      of the game is to list as many words as you can before the time runs out.
      There are several timer modes that determine how much time you start with,
      and if you get extra time when you find a word.
    '';
    homepage = "https://gottcode.org/tanglet/";
    license = [ licenses.gpl3Only ];
    maintainers = [ maintainers.lucastso10 ];
    platforms = platforms.linux;
  };
}
