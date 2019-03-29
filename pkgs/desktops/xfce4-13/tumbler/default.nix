{ mkXfceDerivation, gdk_pixbuf ? null, ffmpegthumbnailer ? null, libgsf ? null
, poppler ? null }:

# TODO: add libopenraw

mkXfceDerivation rec {
  category = "xfce";
  pname = "tumbler";
  version = "0.2.3";

  sha256 = "1gb4dav6q9bn64c2ayi4896cr79lb8k63ja2sm3lwsjxgg1r4hw9";

  buildInputs = [ gdk_pixbuf ffmpegthumbnailer libgsf poppler ];
}
