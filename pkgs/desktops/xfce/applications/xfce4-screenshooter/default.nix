{ lib
, mkXfceDerivation
, wayland-scanner
, exo
, gtk3
, libX11
, libXext
, libXfixes
, libXtst
, libxml2
, libsoup_3
, libxfce4ui
, libxfce4util
, wayland
, wlr-protocols
, xfce4-panel
, xfconf
, curl
, gnome
, jq
, xclip
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.10.6";
  odd-unstable = false;

  sha256 = "sha256-g3wYIyJEnYCFhCs6YXzfEe5lnvIY8ACN/m7He+ww3mA=";

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
    libxml2
    libsoup_3
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
      --prefix PATH : ${lib.makeBinPath [ curl gnome.zenity jq xclip ]}
    )
  '';

  meta = with lib; {
    description = "Screenshot utility for the Xfce desktop";
    mainProgram = "xfce4-screenshooter";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
