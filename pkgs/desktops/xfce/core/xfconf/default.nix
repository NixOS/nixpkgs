{ mkXfceDerivation, libxfce4util, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.16.0";

  sha256 = "00cp2cm1w5a6k7g0fjvqx7d2iwaqw196vii9jkx1aa7mb0f2gk63";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = {
    description = "Simple client-server configuration storage and query system for Xfce";
  };
}
