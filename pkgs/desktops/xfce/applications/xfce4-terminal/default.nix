{ lib
, mkXfceDerivation
, glib
, gtk3
, gtk-layer-shell
, libX11
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
  version = "1.1.1";
  odd-unstable = false;

  sha256 = "sha256-LDfZTZ2EaboIYz+xQNC2NKpJiN8qqfead2XzpKVpL6c=";

  nativeBuildInputs = [
    libxslt
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = [
    glib
    gtk3
    gtk-layer-shell
    libX11
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
