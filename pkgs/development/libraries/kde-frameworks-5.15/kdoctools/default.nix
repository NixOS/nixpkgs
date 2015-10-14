{ kdeFramework, lib, extra-cmake-modules, docbook_xml_dtd_45
, docbook5_xsl, karchive, ki18n, makeKDEWrapper, perl, perlPackages
}:

kdeFramework {
  name = "kdoctools";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive ];
  propagatedBuildInputs = [ ki18n ];
  propagatedNativeBuildInputs = [ makeKDEWrapper perl perlPackages.URI ];
  cmakeFlags = [
    "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/xml/dtd/docbook"
    "-DDocBookXSL_DIR=${docbook5_xsl}/xml/xsl/docbook"
  ];
  patches = [ ./kdoctools-no-find-docbook-xml.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
