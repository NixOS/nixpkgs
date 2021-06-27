{ mkXfceDerivation, gobject-introspection, gtk3, gtksourceview4, gspell }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.5";
  odd-unstable = false;

  sha256 = "sha256-ViiibikQ90S47stb3egXwK5JbcMYYiJAsKukMVYvKLE=";

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [ gtk3 gtksourceview4 gspell ];

  # Use the GSettings keyfile backend rather than DConf
  configureFlags = [ "--enable-keyfile-settings" ];

  meta = {
    description = "Simple text editor for Xfce";
  };
}
