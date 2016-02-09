{ stdenv, fetchurl, ncurses }:

let
  version = "5.0-20160131";
in
stdenv.mkDerivation {
  name = "cdk-${version}";
  inherit version;

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "ftp://invisible-island.net/cdk/cdk-${version}.tgz";
    sha256 = "08ic2f5rmi8niaxwxwr6l6lhpan7690x52vpldnbjcf20rc0fbf3";
  };

  meta = {
    description = "Curses development kit";
    license = stdenv.lib.licenses.bsdOriginal ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
