{ mkXfceDerivation, autoreconfHook, autoconf, automake
, glib, gtk-doc, intltool, libtool }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfce4-dev-tools";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "11g5byxjihgkn0wi7gp8627d04wr59k117lpv53vdbsvv2qgksmg";

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
