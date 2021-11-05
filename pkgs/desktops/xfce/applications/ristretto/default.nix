{ mkXfceDerivation, gtk3, glib, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.12.0";

  sha256 = "sha256-vf9OczDHG6iAd10BgbwfFG7uHBn3JnNT6AB/WGk40C8=";

  buildInputs = [ glib gtk3 libexif libxfce4ui libxfce4util xfconf ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = {
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
  };
}
