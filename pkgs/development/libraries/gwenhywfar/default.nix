{ stdenv, fetchurl, gnutls, gtk, libgcrypt, pkgconfig, qt4 }:

stdenv.mkDerivation rec {
  name = "gwenhywfar-4.11.1";

  src = fetchurl {
    url = "http://www2.aquamaniac.de/sites/download/download.php?package=01&release=78&file=01&dummy=${name}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "0ay79vc03jsw762nax204g112yg5sak340g31bm4hm93q69aiv2b";
  };

  propagatedBuildInputs = [ gnutls libgcrypt ];

  buildInputs = [ gtk qt4 ];

  nativeBuildInputs = [ pkgconfig ];

  QTDIR = qt4;

  meta = with stdenv.lib; {
    description = "OS abstraction functions used by aqbanking and related tools";
    homepage = "http://www2.aquamaniac.de/sites/download/packages.php?package=01&showall=1";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
