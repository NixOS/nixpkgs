{ mkXfceDerivation, docbook_xsl, exo, gtk3, libburn, libisofs, libxfce4ui, libxslt }:

mkXfceDerivation {
  category = "apps";
  pname = "xfburn";
  version = "0.6.2";

  sha256 = "02axhsbbsvd31jb0xs1d2qxr614qb29pajv0sm2p1n1c2cv2fjh1";

  nativeBuildInputs = [ libxslt docbook_xsl ];
  buildInputs = [ exo gtk3 libburn libisofs libxfce4ui ];
}
