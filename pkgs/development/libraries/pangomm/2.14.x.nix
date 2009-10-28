{ stdenv, fetchurl, pkgconfig, pango, glibmm, cairomm, libpng }:

stdenv.mkDerivation rec {
  name = "pangomm-2.14.1";

  src = fetchurl {
    url = "mirror://gnome/sources/pangomm/2.14/${name}.tar.bz2";
    sha256 = "0mrm5hv8kb84qzb97lqbipzzc8g0b97pfgz2hqq33xs2ha3lswnp";
  };

  buildInputs = [ pkgconfig ];
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
  };
}
