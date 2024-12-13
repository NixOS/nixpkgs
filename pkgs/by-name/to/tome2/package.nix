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
  version = "2.4";

  src = fetchFromGitHub {
    owner = "tome2";
    repo = "tome2";
    rev = "4e6a906c80ff07b75a6acf4ff585b47303805e46";
    sha256 = "06bddj55y673d7bnzblk8n01z32l6k2rad3bpzr8dmw464hx4wwf";
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
