{ lib, stdenv, fetchFromGitea, cmake, pkg-config, ncurses, the-foundation }:

stdenv.mkDerivation rec {
  pname = "sealcurses";
  version = "unstable-2022-04-28"; # No release yet

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = pname;
    rev = "abf27cfd2567a0765aaa115cabab0abb7f862253";
    hash = "sha256-c4zi/orHyr1hkuEisqZ9V8SaiH1IoxIbeGMrLBEkZ0A=";
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
