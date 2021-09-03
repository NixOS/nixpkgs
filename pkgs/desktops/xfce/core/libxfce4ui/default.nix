{ lib, mkXfceDerivation, gobject-introspection, vala, gtk3, libICE, libSM
, libstartup_notification, libgtop, epoxy, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.16.0";

  sha256 = "sha256-YmawNgkCM2xwoMKZrY9SxRhm2t0tsmk2j2+grW9zPCk=";

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
