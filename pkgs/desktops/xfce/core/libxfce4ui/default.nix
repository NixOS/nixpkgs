{ lib, mkXfceDerivation, gobject-introspection, vala, gtk3, libICE, libSM
, libstartup_notification, libgtop, libepoxy, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4ui";
<<<<<<< HEAD
  version = "4.18.4";

  sha256 = "sha256-HnLmZftvFvQAvmQ7jZCaYAQ5GB0YMjzhqZkILzvifoE=";
=======
  version = "4.18.3";

  sha256 = "sha256-Wb1nq744HDO4erJ2nJdFD0OMHVh14810TngN3FLFWIA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
