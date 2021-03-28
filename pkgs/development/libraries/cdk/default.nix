{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "cdk";
  version ="5.0-20210109";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/cdk/cdk-${version}.tgz"
      "https://invisible-mirror.net/archives/cdk/cdk-${version}.tgz"
    ];
    sha256 = "sha256-xBbJh793tPGycD18XkM7qUWMi+Uma/RUy/gBrYfnKTY=";
  };

  meta = with lib; {
    description = "Curses development kit";
    license = licenses.bsdOriginal ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
