{ lib, mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf, pcre2, libxslt, docbook_xml_dtd_45, docbook_xsl, nixosTests }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "1.0.4";

  sha256 = "sha256-eCb6KB9fFPuYzNLUm/yYrh+0D60ISzasnv/myStImEI=";

  nativeBuildInputs = [ libxslt docbook_xml_dtd_45 docbook_xsl ];

  buildInputs = [ gtk3 libxfce4ui vte xfconf pcre2 ];

  env.NIX_CFLAGS_COMPILE = "-I${libxfce4ui.dev}/include/xfce4";

  passthru.tests.test = nixosTests.terminal-emulators.xfce4-terminal;

  meta = with lib; {
    description = "A modern terminal emulator";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
