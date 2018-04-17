{ mkXfceDerivation, docbook_xml_xslt, exo, gtk2, libburn, libICE, libisofs, libSM, libxfce4ui, libxslt }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfburn";
  version = "0.5.5";

  postPatch = ''
    substituteInPlace docs/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xml_xslt}/share/xml/docbook-xsl
  '';

  sha256 = "1lmv48vqrlap1a2ha72g16vqly18zvcwj8y3f3f00l10pmn52bkp";

  nativeBuildInputs = [ libxslt ];
  buildInputs = [ exo gtk2 libburn libICE libisofs libSM libxfce4ui ];
}
