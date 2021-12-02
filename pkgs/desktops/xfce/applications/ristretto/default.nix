{ mkXfceDerivation, gtk3, glib, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.12.1";

  sha256 = "sha256-Kwtema8mydSPQadeaw/OTnGCHUNuJpvHbf7l4YtICYE=";

  buildInputs = [ glib gtk3 libexif libxfce4ui libxfce4util xfconf ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = {
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
  };
}
