{ mkXfceDerivation, gobject-introspection, vala, gtk3, gtksourceview4, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.4";
  odd-unstable = false;

  sha256 = "0yrmjs6cyzm08jz8wzrx8wdxj7zdbxn6x625109ckfcfxrkp4a2f";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ gtk3 gtksourceview4 xfconf ];

  meta = {
    description = "Simple text editor for Xfce";
  };
}
