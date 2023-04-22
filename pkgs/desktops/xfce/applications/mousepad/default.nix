{ lib, mkXfceDerivation, gobject-introspection, gtk3, gtksourceview4, gspell }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.6.0";
  odd-unstable = false;

  sha256 = "sha256-VmpCjR8/3rsCGkVGhT+IdC6kaQkGz8G2ktFhJk32DeQ=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 gtksourceview4 gspell ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = with lib; {
    description = "Simple text editor for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
