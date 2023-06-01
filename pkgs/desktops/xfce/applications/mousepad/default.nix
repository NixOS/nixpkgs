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

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = with lib; {
    description = "Simple text editor for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
