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
    sha256 = "0j74l874y33i26y5kjg3pf1vswyjif8k93pqhi0iqykpbxfsg382";
  };
  meta = {
    description = ''Curses development kit'';
    license = stdenv.lib.licenses.bsdOriginal ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
