{ mkXfceDerivation, docbook_xsl, exo, gtk3, libburn, libisofs, libxfce4ui, libxslt }:

mkXfceDerivation {
  category = "apps";
  pname = "xfburn";
  version = "0.6.1";

  sha256 = "0a1ly79x7j5pgr3vbsabb4i0jd5rryaigj9z8iqzr8p9miypx20v";

  nativeBuildInputs = [ libxslt docbook_xsl ];
  buildInputs = [ exo gtk3 libburn libisofs libxfce4ui ];
}
