{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ttyplot";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = finalAttrs.version;
    hash = "sha256-hWjjl11NGhbv0VrLpdJ/W+a8tJPjg8OtUTKgDIqpsfs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Simple general purpose plotting utility for tty with data input from stdin";
    homepage = "https://github.com/tenox7/ttyplot";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lassulus ];
    mainProgram = "ttyplot";
  };
})
