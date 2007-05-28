{stdenv, fetchurl
, pkgconfig, glib, cairo, fontconfig, freetype, pango, gtk
, libxml2, libart

}:

#required: libxml and libart at a minimum, while providing extra features when used with libcroco, libgsf, and mozilla

stdenv.mkDerivation {
  name = "librsvg-2.16.1";
  src = fetchurl {
    url = http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.16/librsvg-2.16.1.tar.gz;
    md5 = "2bbd4f634ef229cbb1552b574aacf0bd";
  };
  propagatedBuildInputs = [ libxml2 libart pkgconfig glib pkgconfig cairo fontconfig freetype pango gtk ];

}
