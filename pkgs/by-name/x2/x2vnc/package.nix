{
  lib,
  stdenv,
  fetchurl,
  libxrandr,
  libxext,
  libx11,
  xorgproto,
}:

stdenv.mkDerivation rec {
  pname = "x2vnc";
  version = "1.7.2";

  src = fetchurl {
    url = "https://fredrik.hubbe.net/x2vnc/x2vnc-${version}.tar.gz";
    sha256 = "00bh9j3m6snyd2fgnzhj5vlkj9ibh69gfny9bfzlxbnivb06s1yw";
  };

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  buildInputs = [
    libx11
    xorgproto
    libxext
    libxrandr
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://fredrik.hubbe.net/x2vnc.html";
    description = "Program to control a remote VNC server";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "x2vnc";
  };
}
