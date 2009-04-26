{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, libxml2, libglade, libgnome
, libgnomecanvas, gettext, intltool }:

assert pkgconfig != null && perl != null && libxml2 != null
  && libglade != null && libgnome != null && libgnomecanvas != null;

# TODO 2.8.1 doesn't work
stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [ pkgconfig perl perlXMLParser libglade gettext intltool ];
  propagatedBuildInputs = [libxml2 libgnome libgnomecanvas];

  LDFLAGS="-lglib-2.0"; # !!! why?
}
