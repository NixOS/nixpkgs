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
, libxfce4ui
, libxfce4util
, wayland
, wlr-protocols
, xfce4-panel
, xfconf
, curl
, zenity
, jq
, xclip
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.11.0";
  odd-unstable = false;

  sha256 = "sha256-DMLGaDHmwDDHvOMev/QKvmDr6AQ6Qnzxf3YCbf0/nXg=";

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
      --prefix PATH : ${lib.makeBinPath [ curl zenity jq xclip ]}
    )
  '';

  meta = with lib; {
    description = "Screenshot utility for the Xfce desktop";
    mainProgram = "xfce4-screenshooter";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
