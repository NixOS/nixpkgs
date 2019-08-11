{stdenv, fetchurl, m4}:

stdenv.mkDerivation {
  name = "beecrypt-4.2.1";
  src = fetchurl {
    url = mirror://sourceforge/beecrypt/beecrypt-4.2.1.tar.gz;
    sha256 = "0pf5k1c4nsj77jfq5ip0ra1gzx2q47xaa0s008fnn6hd11b1yvr8";
  };
  buildInputs = [ m4 ];
  configureFlags = [ "--disable-optimized" "--enable-static" ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
