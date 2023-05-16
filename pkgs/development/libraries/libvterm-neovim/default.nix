{ lib
, stdenv
, fetchurl
, perl
, libtool
}:

stdenv.mkDerivation rec {
  pname = "libvterm-neovim";
  # Releases are not tagged, look at commit history to find latest release
<<<<<<< HEAD
  version = "0.3.2";

  src = fetchurl {
    url = "https://www.leonerd.org.uk/code/libvterm/libvterm-${version}.tar.gz";
    sha256 = "sha256-ketQiAafTm7atp4UxCEvbaAZLmVpWVbcBIAWoNq4vPY=";
=======
  version = "0.3.1";

  src = fetchurl {
    url = "https://www.leonerd.org.uk/code/libvterm/libvterm-${version}.tar.gz";
    sha256 = "sha256-JaitnBVIU2jf0Kip3KGuyP6lwn2j+nTsUY1dN4fww5c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
