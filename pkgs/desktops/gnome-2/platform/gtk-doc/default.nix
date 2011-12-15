{ stdenv, fetchurl, pkgconfig, perl, python, libxml2, libxslt
, docbook_xml_dtd_43, docbook_xsl, gnome_doc_utils, dblatex }:

let version = "1.15"; in
stdenv.mkDerivation {
  name = "gtk-doc-${version}";
  src = fetchurl {
    url = "mirror://gnome/sources/gtk-doc/${version}/gtk-doc-${version}.tar.bz2";
    sha256 = "0ca8wh67nyh574ahlfkx8k9w2bm4ji9yzxvi3afsicqdpyx77k2r";
  };

  # maybe there is a better way to pass the needed dtd and xsl files
  # "-//OASIS//DTD DocBook XML V4.1.2//EN" and "http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"
  preConfigure = ''
    ensureDir $out/nix-support
    cat > $out/nix-support/catalog.xml << EOF
    <?xml version="1.0"?>
    <!DOCTYPE catalog PUBLIC "-//OASIS//DTD Entity Resolution XML Catalog V1.0//EN" "http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd">
    <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
      <nextCatalog  catalog="${docbook_xsl}/xml/xsl/docbook/catalog.xml" />
      <nextCatalog  catalog="${docbook_xml_dtd_43}/xml/dtd/docbook/catalog.xml" />
    </catalog>
    EOF

    configureFlags="--with-xml-catalog=$out/nix-support/catalog.xml --disable-scrollkeeper";
  '';

  buildInputs =
   [ pkgconfig perl python libxml2 libxslt docbook_xml_dtd_43 docbook_xsl
     gnome_doc_utils dblatex
   ];
}
