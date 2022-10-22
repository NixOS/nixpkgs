{ lib
, stdenv
, fetchurl
, perl
, libtool
}:

stdenv.mkDerivation rec {
  pname = "libvterm-neovim";
  # Releases are not tagged, look at commit history to find latest release
  version = "0.3";

  src = fetchurl {
    url = "https://www.leonerd.org.uk/code/libvterm/libvterm-${version}.tar.gz";
    sha256 = "sha256-YesNZijFK98CkA39RGiqhqGnElIourimcyiYGIdIM1g=";
  };

  nativeBuildInputs = [ perl libtool ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "VT220/xterm/ECMA-48 terminal emulator library";
    homepage = "http://www.leonerd.org.uk/code/libvterm/";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
    platforms = platforms.unix;
  };
}
