{ lib, mkXfceDerivation, gobject-introspection, vala, gtk3, libICE, libSM
, libstartup_notification, libgtop, epoxy, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.16.0";

  sha256 = "0a9wfdpsv83giwv6kcidvpd6c665aa7sv6f2l1q6qcq214vb0rk2";

  nativeBuildInputs = [ gobject-introspection vala ];
  buildInputs =  [ gtk3 libstartup_notification libgtop epoxy xfconf ];
  propagatedBuildInputs = [ libxfce4util libICE libSM ];

  configureFlags = [
    "--with-vendor-info='NixOS'"
  ];

  meta = with lib; {
    description = "Widgets library for Xfce";
    license = with licenses; [ lgpl2Plus lgpl21Plus ];
  };
}
