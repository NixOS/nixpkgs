{ lib
, stdenv
, fetchurl
, perl
, libtool
}:

stdenv.mkDerivation rec {
  pname = "libvterm-neovim";
  # Releases are not tagged, look at commit history to find latest release
  version = "0.3.2";

  src = fetchurl {
    url = "https://www.leonerd.org.uk/code/libvterm/libvterm-${version}.tar.gz";
    sha256 = "sha256-ketQiAafTm7atp4UxCEvbaAZLmVpWVbcBIAWoNq4vPY=";
  };

  nativeBuildInputs = [ perl libtool ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LIBTOOL=${libtool}/bin/libtool"
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "VT220/xterm/ECMA-48 terminal emulator library";
    homepage = "http://www.leonerd.org.uk/code/libvterm/";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
    platforms = platforms.unix;
  };
}
