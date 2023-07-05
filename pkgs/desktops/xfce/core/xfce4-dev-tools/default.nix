{ lib
, mkXfceDerivation
, autoreconfHook
, libxslt
, docbook_xsl
, autoconf
, automake
, glib
, gtk-doc
, intltool
, libtool
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-dev-tools";
  version = "4.18.0";

  sha256 = "sha256-VgQiTRMPD1VeUkUnFkX78C2VrsrXFWCdmupL8PQc7+c=";

  nativeBuildInputs = [
    autoreconfHook
    libxslt
    docbook_xsl
  ];

  propagatedBuildInputs = [
    autoconf
    automake
    glib
    gtk-doc
    intltool
    libtool
  ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Autoconf macros and scripts to augment app build systems";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
