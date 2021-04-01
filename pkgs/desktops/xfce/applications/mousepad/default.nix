{ mkXfceDerivation, gobject-introspection, vala, gtk3, gtksourceview3, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "mousepad";
  version = "0.5.3";
  odd-unstable = false;

  sha256 = "0ki5k5p24dpawkyq4k8am1fcq02njhnmhq5vf2ah1zqbc0iyl5yn";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ gtk3 gtksourceview3 xfconf ];

  patches = [ ./allow-checking-parent-sources-when-looking-up-schema.patch ];

  meta = {
    description = "Simple text editor for Xfce";
  };
}
