{
  lib,
  mkXfceDerivation,
  autoreconfHook,
  libxslt,
  docbook_xsl,
  autoconf,
  automake,
  glib,
  gtk-doc,
  intltool,
  libtool,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-dev-tools";
  version = "4.18.1";

  sha256 = "sha256-JUyFlifNVhSnIMaI9qmgCtGIgkpmzYybMfuhPgJiDOg=";

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
