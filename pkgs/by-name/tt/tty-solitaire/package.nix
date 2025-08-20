{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "tty-solitaire";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mpereira";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zMLNWJieHxHALFQoSkdAxGbUBGuZnznLX86lI3P21F0=";
  };

  patches = [
    # Patch pending upstream inclusion to support ncurses-6.3:
    #  https://github.com/mpereira/tty-solitaire/pull/61
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/mpereira/tty-solitaire/commit/4d066c564d086ce272b78cb8f80717a7fb83c261.patch";
      sha256 = "sha256-E1XVG0be6JH3K1y7UPap93s8xk8Nk0dKLdKHcJ7mA8E=";
    })
  ];

  postPatch = ''
    sed -i -e '/^CFLAGS *?= *-g *$/d' Makefile
  '';

  buildInputs = [ ncurses ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Klondike Solitaire in your ncurses terminal";
    license = licenses.mit;
    homepage = "https://github.com/mpereira/tty-solitaire";
    platforms = ncurses.meta.platforms;
    maintainers = [ maintainers.AndersonTorres ];
    mainProgram = "ttysolitaire";
  };
}
