<<<<<<< HEAD
{ lib
, mkXfceDerivation
, gobject-introspection
, glib
, gtk3
, gtksourceview4
, gspell
, enablePolkit ? true
, polkit
}:
=======
{ lib, mkXfceDerivation, gobject-introspection, gtk3, gtksourceview4, gspell }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
<<<<<<< HEAD
  version = "0.6.1";
  odd-unstable = false;

  sha256 = "sha256-MLdexhIsQa4XuVaLgtQ2aVJ00+pwkhAP3qMj0XXPqh0=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [
    glib
    gtk3
    gtksourceview4
    gspell
  ] ++ lib.optionals enablePolkit [
    polkit
  ];
=======
  version = "0.6.0";
  odd-unstable = false;

  sha256 = "sha256-VmpCjR8/3rsCGkVGhT+IdC6kaQkGz8G2ktFhJk32DeQ=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 gtksourceview4 gspell ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = with lib; {
    description = "Simple text editor for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
