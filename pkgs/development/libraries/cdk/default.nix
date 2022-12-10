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

  patches = [
    # Proposed upstream as https://lists.gnu.org/archive/html/bug-ncurses/2021-12/msg00004.html
    ./parallel.patch
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Curses development kit";
    homepage = "https://invisible-island.net/cdk/";
    license = licenses.bsdOriginal ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
