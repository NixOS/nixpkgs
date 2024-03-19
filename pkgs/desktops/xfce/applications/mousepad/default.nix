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

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.6.2";
  odd-unstable = false;

  sha256 = "sha256-A4siNxbTf9ObJJg8inPuH7Lo4dckLbFljV6aPFQxRto=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [
    glib
    gtk3
    gtksourceview4
    gspell
  ] ++ lib.optionals enablePolkit [
    polkit
  ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = with lib; {
    description = "Simple text editor for Xfce";
    mainProgram = "mousepad";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
