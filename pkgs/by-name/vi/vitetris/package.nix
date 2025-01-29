{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "vitetris";
  version = "0.59.1";

  src = fetchFromGitHub {
    owner = "vicgeralds";
    repo = "vitetris";
    rev = "v${version}";
    sha256 = "sha256-Rbfa2hD67RGmInfWwYD4SthL8lm5bGSBi3oudV5hAao=";
  };

  hardeningDisable = [ "format" ];

  makeFlags = [
    "INSTALL=install"
    "CPPFLAGS=-Wno-implicit-int"
  ];

  meta = {
    description = "Terminal-based Tetris clone by Victor Nilsson";
    homepage = "http://www.victornils.net/tetris/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ siers ];
    mainProgram = "tetris";
    platforms = lib.platforms.unix;

    longDescription = ''
      vitetris is a terminal-based Tetris clone by Victor Nilsson. Gameplay is much
      like the early Tetris games by Nintendo.

      Features include: configurable keys, highscore table, two-player mode with
      garbage, network play, joystick (gamepad) support on Linux or with Allegro.
    '';
  };
}
