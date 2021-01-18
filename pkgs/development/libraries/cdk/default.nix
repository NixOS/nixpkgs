{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "cdk";
  version ="5.0-20200923";

  buildInputs = [
    ncurses
  ];

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/cdk/cdk-${version}.tgz"
      "https://invisible-mirror.net/archives/cdk/cdk-${version}.tgz"
    ];
    sha256 = "1vdakz119a13d7p7w53hk56fdmbkhv6y9xvdapcfnbnbh3l5szq0";
  };

  meta = with stdenv.lib; {
    description = "Curses development kit";
    license = licenses.bsdOriginal ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
