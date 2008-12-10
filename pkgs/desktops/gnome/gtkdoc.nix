{ stdenv, gtkdoc, args }: with args;

stdenv.mkDerivation {
  inherit (gtkdoc) name src;

  inherit docbook_xml_dtd_412;
  buildInputs = [ perl 
    libxml2
    xmlto  docbook2x  docbook_xsl docbook_xml_dtd_412 libxslt ];


  # maybe there is a better way to pass the needed dtd and xsl files
  # "-//OASIS//DTD DocBook XML V4.1.2//EN" and "http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"
  preConfigure = ''
    ensureDir $out/nix-support
    cat > $out/nix-support/catalog.xml << EOF
    <?xml version="1.0"?>
    <!DOCTYPE catalog PUBLIC "-//OASIS//DTD Entity Resolution XML Catalog V1.0//EN" "http://www.oasis-open.org/committees/entity/release/1.0/catalog.dtd">
    <catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">
      <nextCatalog  catalog="${docbook_xsl}/xml/xsl/docbook/catalog.xml" />
      <nextCatalog  catalog="${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml" />
    </catalog>
    EOF
    configureFlags="--with-xml-catalog=$out/nix-support/catalog.xml"
  '';
}
