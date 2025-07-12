{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tty-solitaire";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "mpereira";
    repo = "tty-solitaire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8lEF1P2aKh0D4moCu54Z4Tv9xLFkZJzFuXJLo7oF9MQ=";
  };

  postPatch = ''
    sed -i -e '/^CFLAGS *?= *-g *$/d' Makefile
  '';

  buildInputs = [ ncurses ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Klondike Solitaire in your ncurses terminal";
    license = lib.licenses.mit;
    homepage = "https://github.com/mpereira/tty-solitaire";
    platforms = ncurses.meta.platforms;
    maintainers = [ ];
    mainProgram = "ttysolitaire";
  };
})
