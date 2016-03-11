{ stdenv, fetchurl, pkgconfig, efl, zlib, libspectre, gstreamer, gst_plugins_base, gst_ffmpeg, gst_plugins_good, poppler, librsvg, libraw }:
stdenv.mkDerivation rec {
  name = "evas_generic_loaders-${version}";
  version = "1.16.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/evas_generic_loaders/${name}.tar.xz";
    sha256 = "1il3i3rii6ddpj7cw2mdqnb0q2wmhwnvs6qi9janna1n5hhrqyfm";
  };
  buildInputs = [ pkgconfig efl zlib libspectre gstreamer gst_plugins_base gst_ffmpeg gst_plugins_good poppler librsvg libraw ];
  meta = {
    description = "Extra image decoders";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
