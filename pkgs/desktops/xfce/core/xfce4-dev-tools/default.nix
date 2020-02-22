{ mkXfceDerivation, autoreconfHook, autoconf, automake
, glib, gtk-doc, intltool, libtool }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-dev-tools";
  version = "4.14.0";

  sha256 = "10hcj88784faqrk08xb538355cla26vdk9ckx158hqdqv38sb42f";

  nativeBuildInputs = [ autoreconfHook ];

  propagatedBuildInputs = [
    autoconf
    automake
    glib
    gtk-doc
    intltool
    libtool
  ];

  preAutoreconf = ''
    substitute configure.ac.in configure.ac \
      --subst-var-by REVISION UNKNOWN
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Autoconf macros and scripts to augment app build systems";
  };
}
