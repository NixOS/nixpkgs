{ stdenv, lib, fetchzip, libtool, pkgconfig, ncurses }:

stdenv.mkDerivation rec {
  name = "libtermkey-${version}";

  version = "0.20";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/libtermkey-${version}.tar.gz";
    sha256 = "1i5a2zangq61ba1vdkag34ig5g4gzccldccdbcmqmk93saa6lkbx";
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
