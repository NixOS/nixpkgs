{ mkXfceDerivation, autoreconfHook, autoconf, automake, glib, gtk_doc, intltool, libtool }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-dev-tools";
  version = "4.12.0";

  sha256 = "0bbmlmw2dpm10q2wv3vy592i0vx7b5h1qnd35j0fdzxqb8x2hbw2";

  nativeBuildInputs = [ autoreconfHook ];

  propagatedNativeBuildInputs = [
    autoconf
    automake
    glib
    gtk_doc
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
