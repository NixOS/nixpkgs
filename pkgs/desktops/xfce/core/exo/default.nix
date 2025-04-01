{
  lib,
  mkXfceDerivation,
  docbook_xsl,
  glib,
  libxslt,
  gtk3,
  libxfce4ui,
  libxfce4util,
  perl,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "exo";
  version = "4.18.0";

  sha256 = "sha256-oWlKeUD1v2qqb8vY+2Cu9VJ1iThFPVboP12m/ob5KSQ=";

  nativeBuildInputs = [
    libxslt
    docbook_xsl
  ];

  buildInputs = [
    gtk3
    glib
    libxfce4ui
    libxfce4util

    (perl.withPackages (ps: with ps; [ URI ])) # for $out/lib/xfce4/exo/exo-compose-mail
  ];

  # Workaround https://bugzilla.xfce.org/show_bug.cgi?id=15825
  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with lib; {
    description = "Application library for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
