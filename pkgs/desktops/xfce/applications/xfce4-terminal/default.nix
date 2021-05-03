{ mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf, pcre2, libxslt, docbook_xml_dtd_45, docbook_xsl }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "0.8.10";

  sha256 = "0v58qcrdpqpd2nbwlc4ra7j9nkvfzfhb1zcp1kggbn627q86i0ql";

  nativeBuildInputs = [ libxslt docbook_xml_dtd_45 docbook_xsl ];

  buildInputs = [ gtk3 libxfce4ui vte xfconf pcre2 ];

  meta = {
    description = "A modern terminal emulator";
  };
}
