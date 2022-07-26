{ lib, mkXfceDerivation, docbook_xsl, glib, libxslt, gtk3
, libxfce4ui, libxfce4util, perl }:

mkXfceDerivation {
  category = "xfce";
  pname = "exo";
  version = "4.16.4";

  sha256 = "sha256-/BKgQYmDaiptzlTTFqDm2aHykTCHm4MIvWnjxKYi6Es=";

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

  meta = with lib; {
    description = "Application library for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
