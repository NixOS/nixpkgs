{ stdenv, fetchurl, pkgconfig, pango, glibmm, cairomm, libpng, cairo }:

let
  ver_maj = "2.28";
  ver_min = "4";
in
stdenv.mkDerivation rec {
  name = "pangomm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/pangomm/${ver_maj}/${name}.tar.xz";
    sha256 = "10kcdpg080m393f1vz0km41kd3483fkyabprm59gvjwklxkcp3bp";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pango glibmm cairomm libpng cairo ];

  meta = with stdenv.lib; {
    description = "C++ interface to the Pango text rendering library";
    homepage    = http://www.pango.org/;
    license     = with licenses; [ lgpl2 lgpl21 ];
    maintainers = with maintainers; [ lovek323 raskin ];
    platforms   = platforms.unix;

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';
  };
}
