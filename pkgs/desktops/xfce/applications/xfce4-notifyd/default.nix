{ mkXfceDerivation, glib, exo, gtk3, libnotify, libxfce4ui, libxfce4util
, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.6.2";

  sha256 = "1q8n7dffyqbfyy6vpqlmnsfpavlc7iz6hhv1h27fkwzswy2rx28s";

  buildInputs = [ exo gtk3 glib libnotify libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Simple notification daemon for Xfce";
  };
}
