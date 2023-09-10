{ lib, mkXfceDerivation, gobject-introspection, vala, gtk3, libICE, libSM
, libstartup_notification, libgtop, libepoxy, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.18.4";

  sha256 = "sha256-HnLmZftvFvQAvmQ7jZCaYAQ5GB0YMjzhqZkILzvifoE=";

  nativeBuildInputs = [ gobject-introspection vala ];
  buildInputs =  [ gtk3 libstartup_notification libgtop libepoxy xfconf ];
  propagatedBuildInputs = [ libxfce4util libICE libSM ];

  configureFlags = [
    "--with-vendor-info=NixOS"
  ];

  meta = with lib; {
    description = "Widgets library for Xfce";
    license = with licenses; [ lgpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
