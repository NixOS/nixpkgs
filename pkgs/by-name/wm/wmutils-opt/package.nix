{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "wmutils-opt";
  version = "1.0-unstable-2024-09-09";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "opt";
    rev = "77124e003246fce8027452d3ceb440893b18d374";
    sha256 = "sha256-hRxuV4xBvgFLO1Mts4rSq3Z+hedr0ldf/JgUltywH+Y=";
  };

  buildInputs = [
    libxcb
    xorg.xcbutil
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Optional addons to wmutils";
    homepage = "https://github.com/wmutils/opt";
    license = licenses.isc;
    maintainers = with maintainers; [ vifino ];
    platforms = platforms.unix;
  };
}
