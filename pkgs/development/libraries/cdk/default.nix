{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "cdk-${version}";
  version ="5.0-20161210";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    url = "ftp://invisible-island.net/cdk/cdk-${version}.tgz";
    sha256 = "1bazwcwz4qhxyc8jaahdd2nlm30f5dhy0f6cnix5rjjhi35mhxcy";
  };

  meta = with stdenv.lib; {
    description = "Curses development kit";
    license = licenses.bsdOriginal ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
