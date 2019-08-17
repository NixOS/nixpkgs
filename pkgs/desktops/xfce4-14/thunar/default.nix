{ mkXfceDerivation, docbook_xsl, exo, gdk-pixbuf, gtk3, libgudev
, libnotify, libX11, libxfce4ui, libxfce4util, libxslt, xfconf, gobject-introspection, gvfs }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar";
  version = "1.8.9";

  sha256 = "01w60csbs2nq1bhb8n1bnmjmx48fm0va3qbnq84z0h2dxpr80b1w";

  nativeBuildInputs = [ libxslt docbook_xsl gobject-introspection ];

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
    gvfs
  ];
}
