{ mkXfceDerivation, docbook_xsl, libxslt, perlPackages, gtk2, gtk3
, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "exo";
  version = "0.12.2";

  sha256 = "1b4hl9yxvf8b8akqf2zngq3m93yqnqcmxqqds1dwzm9vm5sqydgh";

  nativeBuildInputs = [ libxslt perlPackages.URI ];
  buildInputs = [ gtk2 gtk3 libxfce4ui libxfce4util ];

  postPatch = ''
    substituteInPlace docs/reference/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xsl}/share/xml/docbook-xsl
  '';

  meta = {
    description = "Application library for Xfce";
  };
}
