{
  lib,
  stdenv,
  fetchFromSourcehut,
  pkg-config,
  scdoc,
  wayland-scanner,
  wayland,
  wayland-protocols,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wev";
  version = "1.1.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "wev";
    rev = finalAttrs.version;
    hash = "sha256-0ZA44dMDuVYfplfutOfI2EdPNakE9KnOuRfk+CEDCRk=";
  };

  strictDeps = true;
  # for scdoc
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/wev";
    description = "Wayland event viewer";
    longDescription = ''
      This is a tool for debugging events on a Wayland window, analogous to the
      X11 tool xev.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wineee ];
    platforms = lib.platforms.linux;
    mainProgram = "wev";
  };
})
