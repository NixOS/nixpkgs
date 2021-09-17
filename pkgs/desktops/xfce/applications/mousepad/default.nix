{ mkXfceDerivation, gobject-introspection, gtk3, gtksourceview4, gspell }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.6";
  odd-unstable = false;

  sha256 = "sha256-cdM2NHUnN2FITITb4077Je5Z8xwZAJfjmwXfV+WE6jk=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 gtksourceview4 gspell ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = {
    description = "Simple text editor for Xfce";
  };
}
