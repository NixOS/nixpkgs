{ stdenv, fetchurl, gnutls, gtk, libgcrypt, pkgconfig, qt4 }:

stdenv.mkDerivation rec {
  name = "gwenhywfar-4.10.0beta";

  src = fetchurl {
    url = "http://www2.aquamaniac.de/sites/download/download.php?package=01&release=73&file=01&dummy=gwenhywfar-4.10.0beta.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1ihg2s263g540hl42y6g9wqcc4am70kv01yivsqfrpa9fnhbxm7f";
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
