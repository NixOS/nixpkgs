{lib, stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libcdaudio-0.99.12p2";
  src = fetchurl {
    url = "mirror://sourceforge/libcdaudio/libcdaudio-0.99.12p2.tar.gz";
    sha256 = "1fsy6dlzxrx177qc877qhajm9l4g28mvh06h2l15rxy4bapzknjz" ;
  };

  meta = {
    description = "A portable library for controlling audio CDs";
    homepage = "http://libcdaudio.sourceforge.net";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl2;
  };
}
