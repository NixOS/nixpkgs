{ mkXfceDerivation, gdk_pixbuf ? null, ffmpegthumbnailer ? null, libgsf ? null
, poppler ? null }:

# TODO: add libopenraw

mkXfceDerivation rec {
  category = "xfce";
  pname = "tumbler";
  version = "0.2.1";

  sha256 = "0vgk3s6jnsrs8bawrfc11s8nwsm4jvcl3aidbaznk52g97xiyxz0";

  buildInputs = [ gdk_pixbuf ffmpegthumbnailer libgsf poppler ];
}
