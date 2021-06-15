{ mkXfceDerivation, docbook_xsl, glib, libxslt, gtk3
, libxfce4ui, libxfce4util, perl }:

mkXfceDerivation {
  category = "xfce";
  pname = "exo";
  version = "4.16.2";

  sha256 = "0rsp92j4hkr5jrkrj8anzw9fwd96xbxzpzqzqiyjjwdiq7b29l1v";

  nativeBuildInputs = [
    libxslt
    docbook_xsl
  ];

  buildInputs = [
    gtk3
    glib
    libxfce4ui
    libxfce4util

    (perl.withPackages(ps: with ps; [ URI ])) # for $out/lib/xfce4/exo/exo-compose-mail
  ];

  # Workaround https://bugzilla.xfce.org/show_bug.cgi?id=15825
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = {
    description = "Application library for Xfce";
  };
}
