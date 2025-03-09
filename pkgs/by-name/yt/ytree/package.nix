{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ytree";
  version = "2.06";

  src = fetchurl {
    url = "https://han.de/~werner/ytree-${finalAttrs.version}.tar.gz";
    hash = "sha256-QRqI779ZnnytVUC7A7Zt0zyWexRwBnp+CVQcNvnvWeY=";
  };

  patches = [
    # Two fixups (because diff files can't be smaller):
    # - Create PREFIX instead of using DESTDIR
    # - use gzip without timestamp, to improve reproducibility
    ./0001-use-prefix-and-gzip-n.diff
  ];

  buildInputs = [
    ncurses
    readline
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = {
    homepage = "https://www.han.de/~werner/ytree.html";
    description = "Curses-based file manager similar to DOS Xtree(TM)";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "ytree";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: X11 support
