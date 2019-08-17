{ mkXfceDerivation
, ffmpegthumbnailer
, gdk-pixbuf
, glib
, freetype
, libgsf
, poppler
, libjpeg
, gst_all_1
}:

# TODO: add libopenraw

mkXfceDerivation rec {
  category = "xfce";
  pname = "tumbler";
  version = "0.2.7";

  sha256 = "14ql3fcxyz81qr9s0vcwh6j2ks5fl8jf9scwnkilv5jy0ii9l0ry";

  buildInputs = [
    ffmpegthumbnailer
    freetype
    gdk-pixbuf
    glib
    gst_all_1.gst-plugins-base
    libgsf
    poppler # technically the glib binding
  ];
}
