{ stdenv, fetchurl, libxml2 }:

stdenv.mkDerivation {
  name = "xhtml1-20020801";

  src = fetchurl {
    url = http://www.w3.org/TR/xhtml1/xhtml1.tgz;
    sha256 = "0rr0d89i0z75qvjbm8il93bippx09hbmjwy0y2sj44n9np69x3hl";
  };

  buildInputs = [ libxml2 ];

  installPhase =
    ''
      mkdir -p $out/xml/dtd/xhtml1
      cp DTD/*.ent DTD/*.dtd $out/xml/dtd/xhtml1

      # Generate an XML catalog.
      cat=$out/xml/dtd/xhtml1/catalog.xml
      xmlcatalog --noout --create $cat
      grep PUBLIC DTD/*.soc | while read x; do
          eval a=($x)
          xmlcatalog --noout --add public "''${a[1]}" "''${a[2]}" $cat 
      done
    ''; # */

  meta = {
    homepage = http://www.w3.org/TR/xhtml1/;
    description = "DTDs for XHTML 1.0, the Extensible HyperText Markup Language";
  };
}
