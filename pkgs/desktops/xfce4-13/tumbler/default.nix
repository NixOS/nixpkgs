{ mkXfceDerivation, gdk_pixbuf ? null, ffmpegthumbnailer ? null, libgsf ? null
, poppler ? null }:

# TODO: add libopenraw

mkXfceDerivation rec {
  category = "xfce";
  pname = "tumbler";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "1k579g8dmcfpw1vakspv6k2qkr1y1axyr8cbd0fqjhqdj4pis81i";

  buildInputs = [ gdk_pixbuf ffmpegthumbnailer libgsf poppler ];
}
