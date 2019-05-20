{ mkXfceDerivation, gdk_pixbuf ? null, ffmpegthumbnailer ? null, libgsf ? null
, poppler ? null }:

# TODO: add libopenraw

mkXfceDerivation rec {
  category = "xfce";
  pname = "tumbler";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "1bvcxqs3391dkf36gpfr0hbylsk84nqhv6kf3lf1hq6p7s9f9z3z";

  buildInputs = [ gdk_pixbuf ffmpegthumbnailer libgsf poppler ];
}
