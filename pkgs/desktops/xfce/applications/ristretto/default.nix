{ mkXfceDerivation, gtk3, glib, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.11.0";

  sha256 = "sha256-7hVoQ2cgWTTWMch9CSliAhRDh3qKrMzUaZeaN40l1x4=";

  buildInputs = [ glib gtk3 libexif libxfce4ui libxfce4util xfconf ];

  meta = {
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
  };
}
