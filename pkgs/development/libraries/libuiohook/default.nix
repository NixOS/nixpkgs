{ stdenv
, fetchFromGitHub
, pkg-config
, libtool, autoconf, automake
, x11
, xorg
, libxkbcommon
, lib
, ApplicationServices
, Carbon
}:

with lib;

stdenv.mkDerivation rec {
  pname = "libuiohook";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "kwhat";
    repo = "libuiohook";
    rev = version;
    sha256 = "1isfxn3cfrdqq22d3mlz2lzm4asf9gprs7ww2xy9c3j3srk9kd7r";
  };

  preConfigure = ''
    ./bootstrap.sh
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libtool autoconf automake
  ]
  ++ optionals (stdenv.isLinux) [
    x11
    xorg.libXtst
    xorg.libXinerama
    xorg.libxkbfile
    libxkbcommon
  ]
  ++ optionals (stdenv.isDarwin) [
    ApplicationServices
    Carbon
  ];

  meta = with stdenv.lib; {
    description = "A multi-platform C library to provide global keyboard and mouse hooks from userland.";
    homepage = "https://github.com/kwhat/libuiohook";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin ;
  };
}
