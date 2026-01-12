{
  stdenv,
  lib,
  fetchFromGitHub,
  wxGTK32,
  libGL,
  libGLU,
  pkg-config,
  libx11,
  autoreconfHook,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "wxmacmolplt";
  version = "7.7.3";

  src = fetchFromGitHub {
    owner = "brettbode";
    repo = "wxmacmolplt";
    rev = "v${version}";
    hash = "sha256-gFGstyq9bMmBaIS4QE6N3EIC9GxRvyJYUr8DUvwRQBc=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook4
  ];
  buildInputs = [
    wxGTK32
    libGL
    libGLU
    libx11
    libx11.dev
  ];

  configureFlags = [ "LDFLAGS=-lGL" ];

  enableParallelBuilding = true;

  meta = {
    description = "Graphical user interface for GAMESS-US";
    mainProgram = "wxmacmolplt";
    homepage = "https://brettbode.github.io/wxmacmolplt/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sheepforce
      markuskowa
    ];
  };
}
