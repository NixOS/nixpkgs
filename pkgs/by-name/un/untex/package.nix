{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "untex";
  version = "1.3";

  src = fetchurl {
    url = "ftp://ftp.thp.uni-duisburg.de/pub/source/untex-${finalAttrs.version}.tar.gz";
    sha256 = "1jww43pl9qvg6kwh4h8imp966fzd62dk99pb4s93786lmp3kgdjv";
  };

  hardeningDisable = [ "format" ];

  unpackPhase = "tar xf $src";
  installTargets = [
    "install"
    "install.man"
  ];
  installFlags = [
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man/man1"
  ];
  preBuild = ''
    sed -i '1i#include <stdlib.h>\n#include <string.h>' untex.c
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = {
    description = "Utility which removes LaTeX commands from input";
    mainProgram = "untex";
    homepage = "https://www.ctan.org/pkg/untex";
    license = lib.licenses.gpl1Only;
    maintainers = with lib.maintainers; [ joachifm ];
    platforms = lib.platforms.all;
  };
})
