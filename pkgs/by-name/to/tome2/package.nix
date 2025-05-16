{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  ncurses,
  libX11,
  boost,
  cmake,
}:

let
  pname = "tome2";
  description = "A dungeon crawler similar to Angband, based on the works of Tolkien";

  desktopItem = makeDesktopItem {
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
  };

in
stdenv.mkDerivation {
  inherit pname;
  version = "2.4-unstable-2025-02-17";

  src = fetchFromGitHub {
    owner = "tome2";
    repo = "tome2";
    rev = "3892fbcb1c2446afcb0c34f59e2a24f78ae672c4";
    hash = "sha256-E6T5ZnsAzZ4cy2S8WvB0k3W4XGFsiA3TKTCSBqje+tw=";
  };

  buildInputs = [
    ncurses
    libX11
    boost
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSYSTEM_INSTALL=ON"
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications
  '';

  meta = with lib; {
    inherit description;
    license = licenses.unfree;
    maintainers = with maintainers; [ cizra ];
    platforms = platforms.all;
    homepage = "https://github.com/tome2/tome2";
  };
}
