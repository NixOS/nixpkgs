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

stdenv.mkDerivation (finalAttrs: {
  pname = "unibilium";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "unibilium";
    rev = "v${finalAttrs.version}";
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

  meta = {
    homepage = "https://github.com/neovim/unibilium";
    description = "Very basic terminfo library";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
