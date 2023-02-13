{ lib, mkXfceDerivation, gobject-introspection, gtk3, gtksourceview4, gspell }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.10";
  odd-unstable = false;

  sha256 = "sha256-AKyFCzQE6OfMzKh5Lk16W01255vPeco1II80oLqT4oM=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 gtksourceview4 gspell ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = with lib; {
    description = "Simple text editor for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
