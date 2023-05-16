<<<<<<< HEAD
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
=======
{ lib, mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf, pcre2, libxslt, docbook_xml_dtd_45, docbook_xsl, nixosTests }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
<<<<<<< HEAD
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
=======
  version = "1.0.4";

  sha256 = "sha256-eCb6KB9fFPuYzNLUm/yYrh+0D60ISzasnv/myStImEI=";

  nativeBuildInputs = [ libxslt docbook_xml_dtd_45 docbook_xsl ];

  buildInputs = [ gtk3 libxfce4ui vte xfconf pcre2 ];

  env.NIX_CFLAGS_COMPILE = "-I${libxfce4ui.dev}/include/xfce4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests.test = nixosTests.terminal-emulators.xfce4-terminal;

  meta = with lib; {
    description = "A modern terminal emulator";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
