{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  pkg-config,
  ncurses,
  the-foundation,
}:

stdenv.mkDerivation rec {
  pname = "sealcurses";
  version = "unstable-2023-02-06"; # No release yet

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = pname;
    rev = "e11026ca34b03c5ab546512f82a6f705d0c29e95";
    hash = "sha256-N+Tvg2oIcfa68FC7rKuLxGgEKz1oBEEb8NGCiBuZ8y4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ncurses
    the-foundation
  ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    description = "SDL Emulation and Adaptation Layer for Curses (ncursesw)";
    homepage = "https://git.skyjake.fi/skyjake/sealcurses";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
