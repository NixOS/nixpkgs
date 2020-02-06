{ stdenv, lib, fetchzip, libtool, pkgconfig, ncurses, unibilium }:

stdenv.mkDerivation rec {
  pname = "libtermkey";

  version = "0.22";

  src = fetchzip {
    url = "http://www.leonerd.org.uk/code/libtermkey/libtermkey-${version}.tar.gz";
    sha256 = "02dks6bj7n23lj005yq41azf95wh3hapmgc2lzyh12vigkjh67rg";
  };

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  nativeBuildInputs = [ libtool pkgconfig ];
  buildInputs = [ ncurses unibilium ];

  meta = with lib; {
    description = "Terminal keypress reading library";
    homepage = http://www.leonerd.org.uk/code/libtermkey;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
