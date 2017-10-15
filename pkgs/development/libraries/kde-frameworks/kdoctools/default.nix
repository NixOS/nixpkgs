{
  mkDerivation, lib,
  extra-cmake-modules, docbook_xml_dtd_45, docbook5_xsl,
  karchive, ki18n, qtbase,
  perl, perlPackages
}:

mkDerivation {
  name = "kdoctools";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedNativeBuildInputs = [ perl perlPackages.URI ];
  buildInputs = [ karchive ki18n ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
  patches = [ ./kdoctools-no-find-docbook-xml.patch ];
  cmakeFlags = [
    "-DDocBookXML4_DTD_DIR=${docbook_xml_dtd_45}/share/xml/dtd/docbook"
    "-DDocBookXSL_DIR=${docbook5_xsl}/share/xml/docbook-xsl"
  ];
  postFixup = ''
    moveToOutput "share/doc" "$dev"
    moveToOutput "share/man" "$dev"
  '';
}
