{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "cdk-${version}";
  version ="5.0-20171209";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/cdk/cdk-${version}.tgz"
      "https://invisible-mirror.net/archives/cdk/cdk-${version}.tgz"
    ];
    sha256 = "0jq0dx7gm7gl6lv5mhlfkxhw5362g9dxqdlpjlrag069nns8xdc8";
  };

  meta = with stdenv.lib; {
    description = "Curses development kit";
    license = licenses.bsdOriginal ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
