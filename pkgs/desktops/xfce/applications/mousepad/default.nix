{ lib, mkXfceDerivation, gobject-introspection, gtk3, gtksourceview4, gspell }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.9";
  odd-unstable = false;

  sha256 = "sha256-xuSv2H1+/NNUAm+D8f+f5fPVR97iJ5vIDzPa3S0HLM0=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 gtksourceview4 gspell ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = with lib; {
    description = "Simple text editor for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
