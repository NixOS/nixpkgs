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
  version = "4.16.0";

  sha256 = "sha256-5r9dJfCgXosXoOAtNg1kaPWgFEAmyw/pWTtdG+K1h3A=";

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
