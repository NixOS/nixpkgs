{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "docbook-xsl-ns-1.75.1";
  
  src = fetchurl {
    url = "mirror://sourceforge/docbook/${name}.tar.bz2";
    sha256 = "1ph9ck4w38ycg22m9cws14mx55d04lfgw5fcjn3r8lsdgbm7glrh";
  };

  buildPhase = "true";

  installPhase =
    ''
      ensureDir $out/xml/xsl
      cd ..
      mv docbook-xsl-ns-* $out/xml/xsl/docbook
    '';

  meta = {
    homepage = http://wiki.docbook.org/topic/DocBookXslStylesheets;
    description = "XSL stylesheets for transforming DocBook documents into HTML and various other formats";
  };
}
