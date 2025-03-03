{ lib, mkXfceDerivation, docbook_xsl, glib, libxslt, gtk3
, libxfce4ui, libxfce4util, perl }:

mkXfceDerivation {
  category = "xfce";
  pname = "exo";
  version = "4.20.0";

  sha256 = "sha256-mlGsFaKy96eEAYgYYqtEI4naq5ZSEe3V7nsWGAEucn0=";

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

  meta = with lib; {
    description = "Application library for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
