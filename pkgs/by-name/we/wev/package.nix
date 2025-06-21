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

stdenv.mkDerivation {
  pname = "wev";
  version = "1.0.0-unstable-2022-09-14";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "wev";
    rev = "83de8e931ab04ce3322a58b359d8effa7901b21c";
    sha256 = "sha256-lNFgjRXO/ZbcXJF06DykPoJJ6/a8ZfVA6g95i+rNdWs=";
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

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/wev";
    description = "Wayland event viewer";
    longDescription = ''
      This is a tool for debugging events on a Wayland window, analogous to the
      X11 tool xev.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "wev";
  };
}
