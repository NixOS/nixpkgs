{ stdenv, lib, fetchzip, libtool, pkgconfig, ncurses }:

stdenv.mkDerivation rec {
  name = "libtermkey-${version}";

  version = "0.17";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/libtermkey-${version}.tar.gz";
    sha256 = "085mdshgqsn76gfnnzfns7awv6lals9mgv5a6bybd9f9aj7lvrm5";
  };

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  buildInputs = [ libtool pkgconfig ncurses ];

  meta = with lib; {
    description = "Terminal keypress reading library";
    license = licenses.mit;
  };
}
