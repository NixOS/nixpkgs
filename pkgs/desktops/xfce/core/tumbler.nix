{ stdenv, fetchurl, pkgconfig, intltool, dbus_glib, gdk_pixbuf, curl, freetype
, libgsf, poppler, bzip2 }:
let
  p_name  = "tumbler";
  ver_maj = "0.1";
  ver_min = "31";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0wvip28gm2w061hn84zp2q4dv947ihylrppahn4cjspzff935zfh";
  };

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs = [
    pkgconfig intltool dbus_glib gdk_pixbuf curl freetype
    poppler libgsf bzip2
  ];

  configureFlags = [
    # Needs gst-tag
    # "--enable-gstreamer-thumbnailer"

    # Needs libffmpegthumbnailer
    # "--enable-ffmpeg-thumbnailer"

    "--enable-odf-thumbnailer"
    "--enable-poppler-thumbnailer"
  ];

  meta = with stdenv.lib; {
    homepage = http://git.xfce.org/xfce/tumbler/;
    description = "A D-Bus thumbnailer service";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}

