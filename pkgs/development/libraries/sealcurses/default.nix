{ lib, stdenv, fetchFromGitea, cmake, pkg-config, ncurses, the-foundation }:

stdenv.mkDerivation rec {
  pname = "sealcurses";
  version = "unstable-2022-05-18"; # No release yet

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = pname;
    rev = "417d77d790ede990b4c149f21c58fd13b8f273cc";
    hash = "sha256-yOrJYy9vBv5n8yK6u7tfMq56LBBw5rmhUjORINW8gxo=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ ncurses the-foundation ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    description = "SDL Emulation and Adaptation Layer for Curses (ncursesw)";
    homepage = "https://git.skyjake.fi/skyjake/sealcurses";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
