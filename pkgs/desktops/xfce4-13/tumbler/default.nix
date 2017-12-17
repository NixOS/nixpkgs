{ mkXfceDerivation, gdk_pixbuf ? null, ffmpegthumbnailer ? null, libgsf ? null
, poppler ? null }:

# TODO: add libopenraw

mkXfceDerivation rec {
  category = "xfce";
  pname = "tumbler";
  version = "0.2.0";

  sha256 = "0jr6rhgc57yqb3iwp7y49yf5ig541liaz6xpvjl45ki34j091iaj";

  buildInputs = [ gdk_pixbuf ffmpegthumbnailer libgsf poppler ];
}
