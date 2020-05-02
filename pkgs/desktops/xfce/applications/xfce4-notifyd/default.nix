{ mkXfceDerivation, glib, exo, gtk3, libnotify, libxfce4ui, libxfce4util
, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.6.1";

  sha256 = "18d2q5b54df8j2281lash8gm0826c6apn39q4igfz2zfcyqjh1if";

  buildInputs = [ exo gtk3 glib libnotify libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Simple notification daemon for Xfce";
  };
}
