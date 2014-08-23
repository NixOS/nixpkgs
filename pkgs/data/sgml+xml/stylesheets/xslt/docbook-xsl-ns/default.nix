{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "docbook-xsl-ns-1.78.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/docbook/${name}.tar.bz2";
    sha256 = "1x3sc0axk9z3i6n0jhlsmzlmb723a4sjgslm9g12by6phirdx3ng";
  };

  buildPhase = "true";

  installPhase =
    ''
      mkdir -p $out/xml/xsl
      cd ..
      mv docbook-xsl-ns-* $out/xml/xsl/docbook
    '';

  meta = {
    homepage = http://wiki.docbook.org/topic/DocBookXslStylesheets;
    description = "XSL stylesheets for transforming DocBook documents into HTML and various other formats";
  };
}
