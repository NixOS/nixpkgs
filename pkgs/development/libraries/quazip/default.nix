{ fetchurl, stdenv, zip, zlib, qtbase, qmake }:

stdenv.mkDerivation rec {
  name = "quazip-0.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/quazip/${name}.tar.gz";
    sha256 = "1db9w8ax1ki0p67a47h4cnbwfgi2di4y3k9nc3a610kffiag7m1a";
  };

  preConfigure = "cd quazip";

  buildInputs = [ zlib qtbase ];
  nativeBuildInputs = [ qmake ];

  meta = {
    description = "Provides access to ZIP archives from Qt programs";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://quazip.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
  };
}
