{ autonix, docbook_xml_dtd_45, docbook_xml_xslt }:

with autonix.package;

{
  derivationRules = [
    (manifest: attrs: attrs // {
      setupHook = ./setup-hook.sh;

      cmakeFlags = (attrs.cmakeFlags or []) ++ [
        "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
        "-DDocBookXSL_DIR=${docbook_xml_xslt}/xml/xsl/docbook"
        "-DDocBookXML4_DTD_VERSION=4.5"
        "-DDocBookXML4_FOUND=TRUE"
      ];

      patches = (attrs.patches or []) ++ [
        ./kdoctools-5.3.0-no-find-docbook.patch
      ];
    })
  ];
}
