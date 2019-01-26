{ mkXfceDerivation, docbook_xsl, exo, gdk_pixbuf, gtk3, libgudev ? null
, libnotify ? null, libX11, libxfce4ui, libxfce4util, libxslt, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar";
  version = "1.8.1";

  sha256 = "00n5iinhg3xgzj2rcy7zl6g9449i59x2l09cnlkhyrjzghb4k5ha";

  postPatch = ''
    substituteInPlace docs/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xsl}/share/xml/docbook-xsl
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
