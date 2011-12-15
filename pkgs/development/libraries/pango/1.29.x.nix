{ stdenv, fetchurl_gnome, pkgconfig, gettext, x11, glib, cairo, libpng, xz }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "pango";
    major = "1"; minor = "29"; patchlevel = "4"; extension = "xz";
    sha256 = "0zqjq6ccv6mbah74rcvb03ksq1jwan21z37mdmqa56307sax3s3s";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin gettext;

  buildNativeInputs = [ pkgconfig xz ];

  propagatedBuildInputs = [ x11 glib cairo libpng ];

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = http://www.pango.org/;
    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [ raskin urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
