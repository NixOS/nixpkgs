{ stdenv, lib, fetchFromGitHub, libtool, pkgconfig, perl, ncurses }:

stdenv.mkDerivation rec {
  pname = "unibilium-unstable";

  version = "20190811";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "unibilium";
    rev = "92d929fabaf94ea4feb48149bbc3bbea77c4fab0";
    sha256 = "1l8p3fpdymba62x1f5d990v72z3m5f5g2yf505g0rlf2ysc5r1di";
  };

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ libtool ncurses ];

  meta = with lib; {
    description = "A very basic terminfo library";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
