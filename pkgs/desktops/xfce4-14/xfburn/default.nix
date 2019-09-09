{ mkXfceDerivation, docbook_xsl, exo, gtk2, libburn, libisofs, libxfce4ui, libxslt }:

mkXfceDerivation {
  category = "apps";
  pname = "xfburn";
  version = "0.5.5";

  sha256 = "1lmv48vqrlap1a2ha72g16vqly18zvcwj8y3f3f00l10pmn52bkp";

  nativeBuildInputs = [ libxslt docbook_xsl ];
  buildInputs = [ exo gtk2 libburn libisofs libxfce4ui ];
}
