{ mkXfceDerivation, docbook_xsl, exo, gdk-pixbuf, gtk3, libgudev ? null
, libnotify ? null, libX11, libxfce4ui, libxfce4util, libxslt, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar";
  version = "1.8.9";

  sha256 = "01w60csbs2nq1bhb8n1bnmjmx48fm0va3qbnq84z0h2dxpr80b1w";

  postPatch = ''
    substituteInPlace docs/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xsl}/share/xml/docbook-xsl
  '';

  nativeBuildInputs = [ libxslt ];

  buildInputs = [
    exo
    gdk-pixbuf
    gtk3
    libgudev
    libnotify
    libX11
    libxfce4ui
    libxfce4util
    xfconf
  ];
}
