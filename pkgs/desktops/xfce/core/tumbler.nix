{ stdenv, fetchurl, pkgconfig, intltool, dbus_glib, gdk_pixbuf, curl, freetype,
libgsf, poppler, bzip2 }:

stdenv.mkDerivation rec {
  p_name  = "tumbler";
  ver_maj = "0.1";
  ver_min = "30";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "013kacqyy1vya7kp6jgc1almp3cbbvq96a3r7f5myiihr1whvhp7";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool dbus_glib gdk_pixbuf curl freetype
    poppler libgsf bzip2];

  configureFlags = [
    # Needs gst-tag
    # "--enable-gstreamer-thumbnailer"

    # Needs libffmpegthumbnailer
    # "--enable-ffmpeg-thumbnailer"
    
    "--enable-odf-thumbnailer"
    "--enable-poppler-thumbnailer"
  ];

  meta = {
    homepage = http://git.xfce.org/xfce/tumbler/;
    description = "A D-Bus thumbnailer service";
    platforms = stdenv.lib.platforms.linux;
    license = "GPLv2";
  };
}
