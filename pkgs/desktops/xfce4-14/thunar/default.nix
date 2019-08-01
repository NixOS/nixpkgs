{ mkXfceDerivation, docbook_xsl, exo, gdk_pixbuf, gtk3, libgudev ? null
, libnotify ? null, libX11, libxfce4ui, libxfce4util, libxslt, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "0b17yf8ss8s8xyr65v4zrq15ayr5nskqpxy4wxah33n7lz09dh8r";

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
