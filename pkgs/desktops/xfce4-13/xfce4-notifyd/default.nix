{ mkXfceDerivation, dbus_glib, exo, gtk3, libnotify, libxfce4ui, libxfce4util
, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.4.1";

  sha256 = "12mqi0q1hcjm16f4pndq7l58h2n0nq160r5fqx8ns320i83nh94k";

  nativeBuildInputs = [ dbus_glib exo ];
  buildInputs = [ gtk3 libnotify libxfce4ui libxfce4util xfce4-panel xfconf ];
}
