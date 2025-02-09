{
  lib,
  mkXfceDerivation,
  fetchpatch,
  exo,
  gtk3,
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  libyaml,
  xfconf,
  libnotify,
  garcon,
  gtk-layer-shell,
  thunar,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.20.0";

  sha256 = "sha256-80g3lk1TkQI0fbYf2nXs36TrPlaGTHgH6k/TGOzRd3w=";

  patches = [
    # Fix monitor chooser UI resource path
    # https://gitlab.xfce.org/xfce/xfdesktop/-/merge_requests/181
    (fetchpatch {
      url = "https://gitlab.xfce.org/xfce/xfdesktop/-/commit/699e21b062f56bdc0db192bfe036420b2618612e.patch";
      hash = "sha256-YTtXF+OJMHn6KY2xui1qGZ04np9a60asne+8ZS/dujs=";
    })
  ];

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libxfce4windowing
    libyaml
    xfconf
    libnotify
    garcon
    gtk-layer-shell
    thunar
  ];

  meta = with lib; {
    description = "Xfce's desktop manager";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
