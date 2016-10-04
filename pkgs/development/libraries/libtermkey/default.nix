{ stdenv, lib, fetchzip, libtool, pkgconfig, ncurses }:

stdenv.mkDerivation rec {
  name = "libtermkey-${version}";

  version = "0.18";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/libtermkey-${version}.tar.gz";
    sha256 = "0a0ih1a114phzmyq6jzgbp03x97463fwvrp1cgnl26awqw3f8sbf";
  };

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  buildInputs = [ libtool pkgconfig ncurses ];

  meta = with lib; {
    description = "Terminal keypress reading library";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
