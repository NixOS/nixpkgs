{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ttyplot";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    hash = "sha256-XPWfSL1395TBkUmAO5kB9TdAZHL011o6t/2s01W/kk8=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple general purpose plotting utility for tty with data input from stdin";
    homepage = "https://github.com/tenox7/ttyplot";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ lassulus ];
    mainProgram = "ttyplot";
  };
}
