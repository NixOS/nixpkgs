{
  lib,
  stdenv,
  fetchzip,
  libx11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xtris";
  version = "1.15";

  src = fetchzip {
    url = "https://web.archive.org/web/20120315061213/http://www.iagora.com/~espel/xtris/xtris-${finalAttrs.version}.tar.gz";
    sha256 = "1vqva99lyv7r6f9c7yikk8ahcfh9aq3clvwm4pz964wlbr9mj1v6";
  };

  patchPhase = ''
    sed -i '
      s:/usr/local/bin:'$out'/bin:
      s:/usr/local/man:'$out'/share/man:
      s:mkdir:mkdir -p:g
      s:^CFLAGS:#CFLAGS:
    ' Makefile

    sed -i '28i#include <time.h>' xtserv.c
    sed -i '35i#include <time.h>' xtbot.c
  '';
  buildInputs = [ libx11 ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = {
    description = "Multi-player version of the classical game of Tetris, for the X Window system";
    homepage = "https://web.archive.org/web/20120315061213/http://www.iagora.com/~espel/xtris/xtris.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
