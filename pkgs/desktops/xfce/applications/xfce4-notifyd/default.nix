{ mkXfceDerivation, glib, exo, gtk3, libnotify, libxfce4ui, libxfce4util
, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.6.2";

  sha256 = "sha256-Gomehef68+mOgGFDaH48jG51nbaV4ruN925h71w7FuE=";

  buildInputs = [ exo gtk3 glib libnotify libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Simple notification daemon for Xfce";
  };
}
