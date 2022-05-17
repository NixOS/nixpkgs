{ lib, mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf, pcre2, libxslt, docbook_xml_dtd_45, docbook_xsl, nixosTests }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "1.0.3";

  sha256 = "sha256-oZOnPAfvSXCreFHTIZYpJhOdtlDOHrAUMvGIjYU+TRU=";

  nativeBuildInputs = [ libxslt docbook_xml_dtd_45 docbook_xsl ];

  buildInputs = [ gtk3 libxfce4ui vte xfconf pcre2 ];

  passthru.tests.test = nixosTests.terminal-emulators.xfce4-terminal;

  meta = with lib; {
    description = "A modern terminal emulator";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
