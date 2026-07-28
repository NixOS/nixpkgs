{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "typespeed";
  version = "0.6.5";
  buildInputs = [ ncurses ];
  src = fetchurl {
    url = "https://typespeed.sourceforge.net/typespeed-${finalAttrs.version}.tar.gz";
    sha256 = "5c860385ceed8a60f13217cc0192c4c2b4705c3e80f9866f7d72ff306eb72961";
  };

  patches = [ ./typespeed-config-in-home.patch ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: typespeed-typespeed.o:/build/typespeed-0.6.5/src/typespeed.h:69: multiple definition of
  #     `opt'; typespeed-file.o:/build/typespeed-0.6.5/src/typespeed.h:69: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  configureFlags = [ "--datadir=\${out}/share/" ];
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = {
    description = "Curses based typing game";
    mainProgram = "typespeed";
    homepage = "https://typespeed.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.auntie ];
  };
})
