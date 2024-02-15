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
  version = "1.1.2";
  odd-unstable = false;

  sha256 = "sha256-9RJmHYT9yYhtyzyTcg3nnD2hlCgENyi/3TNOGUto494=";

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
