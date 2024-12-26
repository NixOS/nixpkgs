{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tm";
  version = "0.4.1";

  src = fetchurl {
    url = "https://vicerveza.homeunix.net/~viric/soft/tm/tm-${version}.tar.gz";
    sha256 = "3b389bc03b6964ad5ffa57a344b891fdbcf7c9b2604adda723a863f83657c4a0";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -i 's@/usr/bin/install@install@g ; s/gcc/cc/g' Makefile
  '';

  meta = with lib; {
    description = "Terminal mixer - multiplexer for the i/o of terminal applications";
    homepage = "http://vicerveza.homeunix.net/~viric/soft/tm";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "tm";
  };
}
