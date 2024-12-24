{
  lib,
  mkXfceDerivation,
  wayland-scanner,
  exo,
  gtk3,
  libX11,
  libXext,
  libXfixes,
  libXtst,
  libxfce4ui,
  libxfce4util,
  wayland,
  wlr-protocols,
  xfce4-panel,
  xfconf,
  curl,
  zenity,
  jq,
  xclip,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.11.1";
  odd-unstable = false;

  sha256 = "sha256-/N79YK233k9rVg5fGr27b8AZD9bCXllNQvrN4ghir/M=";

  nativeBuildInputs = [
    wayland-scanner
  ];

  buildInputs = [
    exo
    gtk3
    libX11
    libXext
    libXfixes
    libXtst
    libxfce4ui
    libxfce4util
    wayland
    wlr-protocols
    xfce4-panel
    xfconf
  ];

  preFixup = ''
    # For Imgur upload action
    # https://gitlab.xfce.org/apps/xfce4-screenshooter/-/merge_requests/51
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          zenity
          jq
          xclip
        ]
      }
    )
  '';

  meta = with lib; {
    description = "Screenshot utility for the Xfce desktop";
    mainProgram = "xfce4-screenshooter";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
