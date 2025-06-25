{
  stdenv,
  lib,
  fetchFromGitHub,
  libtool,
  pkg-config,
  perl,
  ncurses,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "unibilium";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "unibilium";
    rev = "v${version}";
    sha256 = "sha256-6bFZtR8TUZJembRBj6wUUCyurUdsn3vDGnCzCti/ESc=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
    libtool
  ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "https://github.com/neovim/unibilium";
    description = "Very basic terminfo library";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
