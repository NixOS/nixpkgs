{ mkXfceDerivation, docbook_xml_xslt, exo, gdk_pixbuf, gtk3, libgudev ? null
, libnotify ? null, libX11, libxfce4ui, libxfce4util, libxslt, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar";
  version = "1.7.0";

  sha256 = "1s262hii524a5hb15pb8xbrrrhyi5fj3837zgbscg3rdnsm52igw";

  postPatch = ''
    substituteInPlace docs/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xml_xslt}/share/xml/docbook-xsl
  '';

  nativeBuildInputs = [ libxslt ];

  buildInputs = [
    exo
    gdk_pixbuf
    gtk3
    libgudev
    libnotify
    libX11
    libxfce4ui
    libxfce4util
    xfconf
  ];
}
