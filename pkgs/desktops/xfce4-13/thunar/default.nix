{ mkXfceDerivation, docbook_xsl, exo, gdk_pixbuf, gtk3, libgudev ? null
, libnotify ? null, libX11, libxfce4ui, libxfce4util, libxslt, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "13l1nw526jz80p0ynhxqd3a8flp561z0321z7h4rvnidicvdr32n";

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
