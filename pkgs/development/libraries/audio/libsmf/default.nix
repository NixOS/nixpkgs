{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.3";
  pname = "libsmf";

  src = fetchFromGitHub {
    owner = "stump";
    repo = "libsmf";
    rev = "libsmf-${version}";
    sha256 = "sha256-OJXJkXvbM2GQNInZXU2ldObquKHhqkdu1zqUDnVZN0Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ glib ];

  meta = with lib; {
    description = "A C library for reading and writing Standard MIDI Files";
    homepage = "https://github.com/stump/libsmf";
    license = licenses.bsd2;
    maintainers = [ maintainers.goibhniu ];
    mainProgram = "smfsh";
    platforms = platforms.unix;
  };
}
