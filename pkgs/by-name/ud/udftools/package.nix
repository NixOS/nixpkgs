{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  readline,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "udftools";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "udftools";
    tag = version;
    hash = "sha256-SUdwJpJfbs6LhcyNMPJUhhpp/3htwT/EVep7+4PRgto=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    readline
  ];

  hardeningDisable = [ "fortify" ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu99";

  preConfigure = ''
    sed -e '1i#include <limits.h>' -i cdrwtool/cdrwtool.c -i pktsetup/pktsetup.c
    sed -e 's@[(]char[*][)]spm [+]=@spm = ((char*) spm) + @' -i wrudf/wrudf.c
    sed -e '38i#include <string.h>' -i wrudf/wrudf-cdrw.c
    sed -e '12i#include <string.h>' -i wrudf/wrudf-cdr.c
    sed -e '37i#include <stdlib.h>' -i wrudf/ide-pc.c
    sed -e '46i#include <sys/sysmacros.h>' -i mkudffs/main.c
    sed -e "s@\$(DESTDIR)/lib/udev/rules.d@$out/lib/udev/rules.d@" -i pktsetup/Makefile.am
  '';

  meta = {
    description = "UDF tools";
    homepage = "https://github.com/pali/udftools";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
