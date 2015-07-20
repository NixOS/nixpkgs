{stdenv, fetchurl, ncurses}:
let
  buildInputs = [
    ncurses
  ];
in
stdenv.mkDerivation {
  name = "cdk";
  inherit buildInputs;
  src = fetchurl {
    url = "http://invisible-island.net/datafiles/release/cdk.tar.gz";
    sha256 = "00s87kq5x10x22azr6q17b663syk169y3dk3kaj8z6dlk2b8vknp";
  };
  meta = {
    description = ''Curses development kit'';
    license = stdenv.lib.licenses.bsdOriginal ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
