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
  version = "4.20.0";

  sha256 = "sha256-mlGsFaKy96eEAYgYYqtEI4naq5ZSEe3V7nsWGAEucn0=";

  nativeBuildInputs = [
    libxslt
    docbook_xsl
    perl
  ];

  buildInputs = [
    gtk3
    glib
    libxfce4ui
    libxfce4util
  ];

  meta = with lib; {
    description = "Application library for Xfce";
    teams = [ teams.xfce ];
  };
}
