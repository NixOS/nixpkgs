<<<<<<< HEAD
{ lib
, mkXfceDerivation
, polkit
, exo
, libxfce4util
, libxfce4ui
, xfconf
, iceauth
, gtk3
, glib
, libwnck
, xfce4-session
}:
=======
{ lib, mkXfceDerivation, polkit, exo, libxfce4util, libxfce4ui, xfconf, iceauth, gtk3, glib, libwnck, xfce4-session }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-session";
<<<<<<< HEAD
  version = "4.18.3";

  sha256 = "sha256-qCkE3aVYVwphoO1ZAyzpL1ZtsLaP6XT1H1rlFoBI3yg=";

  buildInputs = [
    exo
    gtk3
    glib
    libxfce4ui
    libxfce4util
    libwnck
    xfconf
    polkit
    iceauth
  ];
=======
  version = "4.18.2";

  sha256 = "sha256-EyDMHGFjZWux7atpiUoCMmJIN2PGlF9h2L5qaFAzrKU=";

  buildInputs = [ exo gtk3 glib libxfce4ui libxfce4util libwnck xfconf polkit iceauth ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  configureFlags = [ "--with-xsession-prefix=${placeholder "out"}" ];

  # See https://github.com/NixOS/nixpkgs/issues/36468
  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  passthru.xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  meta = with lib; {
    description = "Session manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
