{ mkXfceDerivation, glib, exo, gtk3, libnotify, libxfce4ui, libxfce4util
, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.6.0";

  sha256 = "03lw7zil6pwvx537ibqrynxjz7d6iq6in7vdskrnnn16kfg6hjg2";

  buildInputs = [ exo gtk3 glib libnotify libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Simple notification daemon for Xfce";
  };
}
