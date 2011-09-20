{ stdenv, fetchurl_gnome, pkgconfig, pango, glibmm, cairomm, libpng }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "pangomm";
    major = "2"; minor = "28"; patchlevel = "2";
    sha256 = "13yq5zwxzliiss4ladaa7di2b3s965p3zbz7s0ccz9ddbqj9f7gc";
  };

  buildNativeInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pango glibmm cairomm libpng ];

  meta = {
    description = "C++ interface to the Pango text rendering library";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = http://www.pango.org/;
    license = "LGPLv2+";

    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
