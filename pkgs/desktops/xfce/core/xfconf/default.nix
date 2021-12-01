{ mkXfceDerivation, libxfce4util, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.16.0";

  sha256 = "sha256-w8wnHFj1KBX6lCnGbVLgWPEo2ul4SwfemUYVHioTlwE=";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = {
    description = "Simple client-server configuration storage and query system for Xfce";
  };
}
