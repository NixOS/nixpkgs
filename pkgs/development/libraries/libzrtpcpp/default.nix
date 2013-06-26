{ stdenv, fetchurl, cmake, openssl, pkgconfig, ccrtp }:

stdenv.mkDerivation rec {
  name = "libzrtpcpp-2.0.0";

  src = fetchurl {
    url = "mirror://gnu/ccrtp/${name}.tar.gz";
    sha256 = "05yw8n5xpj0jxkvzgsvn3xkxirpypc1japy9k1jqs9301fgb1a3i";
  };

  # We disallow 'lib64', or pkgconfig will not find it.
  prePatch = ''
    sed -i s/lib64/lib/ CMakeLists.txt
  '';

  buildInputs = [ cmake openssl pkgconfig ccrtp ];

  meta = { 
    description = "GNU RTP stack for the zrtp protocol developed by Phil Zimmermann";
    homepage = "http://www.gnutelephony.org/index.php/GNU_ZRTP";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
