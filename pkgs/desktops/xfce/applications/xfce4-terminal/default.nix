{ lib
, mkXfceDerivation
, glib
, gtk3
, libxfce4ui
, vte
, xfconf
, pcre2
, libxslt
, docbook_xml_dtd_45
, docbook_xsl
, nixosTests
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "1.1.0";

  sha256 = "sha256-ilxiP1Org5/uSQOzfRgODmouH0BmK3CmCJj1kutNuII=";

  nativeBuildInputs = [
    libxslt
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    vte
    xfconf
    pcre2
  ];

  passthru.tests.test = nixosTests.terminal-emulators.xfce4-terminal;

  meta = with lib; {
    description = "A modern terminal emulator";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
