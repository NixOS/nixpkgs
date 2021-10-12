{ mkXfceDerivation, gobject-introspection, gtk3, gtksourceview4, gspell }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.7";
  odd-unstable = false;

  sha256 = "sha256-VLPzzM9dl+HAPI+Qn2QTjrKfRgngsExlPFRsdmsNcSM=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 gtksourceview4 gspell ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = {
    description = "Simple text editor for Xfce";
  };
}
