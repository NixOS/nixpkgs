{ input, stdenv, fetchurl, pkgconfig, perl, perlXMLParser, libxml2, libglade, libgnome
, libgnomecanvas, gettext}:

assert pkgconfig != null && perl != null && libxml2 != null
  && libglade != null && libgnome != null && libgnomecanvas != null;

# todo 2.8.1 doesn;t work
stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig perl libglade gettext];
  propagatedBuildInputs = [libxml2 libgnome libgnomecanvas];

  PERL5LIB = perlXMLParser ~ "/lib/site_perl";

  LDFLAGS="-lglib-2.0";
}
