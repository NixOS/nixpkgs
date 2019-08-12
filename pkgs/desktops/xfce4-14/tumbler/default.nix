{ mkXfceDerivation, gdk-pixbuf ? null, ffmpegthumbnailer ? null, libgsf ? null
, poppler ? null }:

# TODO: add libopenraw

mkXfceDerivation rec {
  category = "xfce";
  pname = "tumbler";
  version = "0.2.7";

  sha256 = "14ql3fcxyz81qr9s0vcwh6j2ks5fl8jf9scwnkilv5jy0ii9l0ry";

  buildInputs = [ gdk-pixbuf ffmpegthumbnailer libgsf poppler ];
}
