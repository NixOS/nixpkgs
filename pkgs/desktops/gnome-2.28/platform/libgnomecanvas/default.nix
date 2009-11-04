{ stdenv, fetchurl, pkgconfig, gtk, intltool, libart_lgpl, libglade }:

stdenv.mkDerivation {
  name = "libgnomecanvas-2.26.0";
  
  src = fetchurl {
    url = mirror://gnome/sources/libgnomecanvas/2.26/libgnomecanvas-2.26.0.tar.bz2;
    sha256 = "13f5rf5pkp9hnyxzvssrxnlykjaixa7vrig9a7v06wrxqfn81d40";
  };
  
  buildInputs = [ pkgconfig intltool libglade ];

  propagatedBuildInputs = [ libart_lgpl gtk ];
}
