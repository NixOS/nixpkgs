{ stdenv, lib, fetchFromGitHub, libtool, pkgconfig, perl, ncurses }:

stdenv.mkDerivation rec {
  name = "unibilium-${version}";

  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mauke";
    repo = "unibilium";
    rev = "v${version}";
    sha256 = "1wa9a32wzqnxqh1jh554afj13dzjr6mw2wzqzw8d08nza9pg2ra2";
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
