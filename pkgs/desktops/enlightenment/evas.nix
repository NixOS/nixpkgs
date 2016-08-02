{ stdenv, fetchurl, pkgconfig, efl, zlib, libspectre, gst_all, poppler, librsvg, libraw }:
stdenv.mkDerivation rec {
  name = "evas_generic_loaders-${version}";
  version = "1.17.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/evas_generic_loaders/${name}.tar.xz";
    sha256 = "0ynq1nx0bfgg19p4vki1fap36yyip53zaxpzncx2slr6jcx1kxf2";
  };
  buildInputs = with gst_all; [ pkgconfig efl zlib libspectre gstreamer gst-plugins-base gst-ffmpeg gst-plugins-good poppler librsvg libraw ];
  meta = {
    description = "Extra image decoders";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
