{ mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf, pcre2, libxslt, docbook_xml_dtd_45, docbook_xsl }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "0.8.10";

  sha256 = "sha256-FINoED7C2PXeDJf9sKD7bk+b5FGZMMqXFe3i2zLDqGw=";

  nativeBuildInputs = [ libxslt docbook_xml_dtd_45 docbook_xsl ];

  buildInputs = [ gtk3 libxfce4ui vte xfconf pcre2 ];

  meta = {
    description = "A modern terminal emulator";
  };
}
