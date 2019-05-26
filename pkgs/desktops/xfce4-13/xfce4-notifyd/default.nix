{ mkXfceDerivation, dbus-glib, exo, gtk3, libnotify, libxfce4ui, libxfce4util
, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-notifyd";
  version = "0.4.2";

  sha256 = "1zxwzigrhms74crasbqpnzidmq2mnyxpmc9pqr4p4qj14yw4sam9";

  buildInputs = [ dbus-glib exo gtk3 libnotify libxfce4ui libxfce4util xfce4-panel xfconf ];
}
