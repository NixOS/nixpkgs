{ stdenv, fetchurl, pkgconfig, e19, zlib, libspectre, gstreamer, gst_plugins_base, gst_ffmpeg, gst_plugins_good, poppler, librsvg, libraw }:
stdenv.mkDerivation rec {
  name = "evas_generic_loaders-${version}";
  version = "1.11.2";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/evas_generic_loaders/${name}.tar.gz";
    sha256 = "03p6v7l2fxvldiymqk16pqnbm9llygp6i19qhn3rmrqy1hkjkry6";
  };
  buildInputs = [ pkgconfig e19.efl zlib libspectre gstreamer gst_plugins_base gst_ffmpeg gst_plugins_good poppler librsvg libraw ];
  meta = {
    description = "Extra image decoders";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
