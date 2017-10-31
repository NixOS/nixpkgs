{ stdenv, lib, fetchzip, libtool, pkgconfig, ncurses }:

stdenv.mkDerivation rec {
  name = "libtermkey-${version}";

  version = "0.19";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/libtermkey-${version}.tar.gz";
    sha256 = "0v85h0zacd5lqwkykl2ms4009x8mfidzb6jr4dsq4gh7kwm54w56";
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
