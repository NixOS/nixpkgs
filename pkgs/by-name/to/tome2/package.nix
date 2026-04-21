{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  ncurses,
  libx11,
  boost,
  cmake,
}:

let
  pname = "tome2";
  description = "Dungeon crawler similar to Angband, based on the works of Tolkien";

in
stdenv.mkDerivation {
  inherit pname;
  version = "2.4-unstable-2025-02-17";

  src = fetchFromGitHub {
    owner = "tome2";
    repo = "tome2";
    rev = "3892fbcb1c2446afcb0c34f59e2a24f78ae672c4";
    hash = "sha256-OL59zktCJGBHPE8Y89S+OdcnJ/Hj+dGif1DNhePEQXo=";
  };

  buildInputs = [
    ncurses
    libx11
    boost
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
  ];

  cmakeFlags = [
    "-DSYSTEM_INSTALL=ON"
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = pname;
      name = pname;
      exec = "${pname}-x11";
      icon = pname;
      comment = description;
      type = "Application";
      categories = [
        "Game"
        "RolePlaying"
      ];
      genericName = pname;
    })
  ];

  meta = {
    inherit description;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ cizra ];
    platforms = lib.platforms.all;
    homepage = "https://github.com/tome2/tome2";
  };
}
