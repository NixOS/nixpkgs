{ stdenv, fetchurl, qt4, gtk, pkgconfig, gnutls, libgcrypt }:

stdenv.mkDerivation rec {
  name = "gwenhywfar-4.3.1";

  src = fetchurl {
    url = "http://www2.aquamaniac.de/sites/download/download.php?package=01&release=65&file=01&dummy=gwenhywfar-4.3.1.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1r8ayi1nwcdcs4mncd7zigl8pk707j7whb85klsyir4nif52fxrs";
  };

  propagatedBuildInputs = [ gnutls libgcrypt ];

  buildInputs = [ qt4 gtk ];

  nativeBuildInputs = [ pkgconfig ];

  QTDIR = qt4;
}
