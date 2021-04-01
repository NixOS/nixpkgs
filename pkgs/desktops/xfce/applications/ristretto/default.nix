{ mkXfceDerivation, gtk3, glib, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.10.0";

  sha256 = "07h7wbq3xh2ac6q4kp2ai1incfn0zfxxngap7hzqx47a5xw2mrm8";

  buildInputs = [ glib gtk3 libexif libxfce4ui libxfce4util xfconf ];

  postPatch = ''
    # exo-csource has been dropped from exo
    substituteInPlace src/Makefile.am --replace exo-csource xdt-csource
  '';

  meta = {
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
  };
}
