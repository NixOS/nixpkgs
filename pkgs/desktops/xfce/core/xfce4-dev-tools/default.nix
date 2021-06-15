{ mkXfceDerivation
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

  sha256 = "0w47npi1np9vb7lhzjr680aa1xb8ch6kcbg0l0bqnpm0y0jmvgz6";

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

  meta = {
    description = "Autoconf macros and scripts to augment app build systems";
  };
}
