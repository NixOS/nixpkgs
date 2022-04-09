{ lib, mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf, pcre2, libxslt, docbook_xml_dtd_45, docbook_xsl, nixosTests }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "0.8.10";

  sha256 = "sha256-FINoED7C2PXeDJf9sKD7bk+b5FGZMMqXFe3i2zLDqGw=";

  nativeBuildInputs = [ libxslt docbook_xml_dtd_45 docbook_xsl ];

  buildInputs = [ gtk3 libxfce4ui vte xfconf pcre2 ];

  passthru.tests.test = nixosTests.terminal-emulators.xfce4-terminal;

  meta = with lib; {
    description = "A modern terminal emulator";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
