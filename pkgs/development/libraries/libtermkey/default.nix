{ stdenv, lib, fetchzip, libtool, pkgconfig, ncurses }:

stdenv.mkDerivation rec {
  name = "libtermkey-${version}";

  version = "0.21.1";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/libtermkey-${version}.tar.gz";
    sha256 = "1gflgcdgck2jardfz0pzp8wpk9cmdv4zsh5vjm1a00yiirvil9as";
  };

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libtool ncurses ];

  meta = with lib; {
    description = "Terminal keypress reading library";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
