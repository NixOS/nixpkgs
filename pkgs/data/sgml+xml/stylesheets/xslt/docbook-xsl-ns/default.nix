{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "docbook-xsl-ns-1.75.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/docbook/${name}.tar.bz2";
    sha256 = "1pr7m0hmqilk25hjx33kq2vqn2xf6cx6zhxqm35fdvnjccazlxg2";
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
