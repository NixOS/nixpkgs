{ mkXfceDerivation, docbook_xml_xslt, libxslt, perlPackages, gtk2, gtk3
, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "exo";
  version = "0.11.5";

  sha256 = "0zxv7cx1xbjls7q2blv8ir9zwzyq7r189n6q35jwasns7rxj256v";

  nativeBuildInputs = [ libxslt perlPackages.URI ];
  buildInputs = [ gtk2 gtk3 libxfce4ui libxfce4util ];

  postPatch = ''
    substituteInPlace docs/reference/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xml_xslt}/share/xml/docbook-xsl
  '';

  meta = {
    description = "Application library for Xfce";
  };
}
