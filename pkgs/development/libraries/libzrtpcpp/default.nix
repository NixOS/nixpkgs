{ stdenv, fetchurl, cmake, openssl, pkgconfig, ccrtp }:

stdenv.mkDerivation rec {
  name = "libzrtpcpp-2.3.3";

  src = fetchurl {
    url = "mirror://gnu/ccrtp/${name}.tar.gz";
    sha256 = "1p8i3qb4j1r64r7miva8hamaszk42kncpy1x5xlq1l0465h01rvg";
  };

  # We disallow 'lib64', or pkgconfig will not find it.
  prePatch = ''
    sed -i s/lib64/lib/ CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  propagatedBuildInputs = [ openssl ccrtp ];

  meta = { 
    description = "GNU RTP stack for the zrtp protocol developed by Phil Zimmermann";
    homepage = "http://www.gnutelephony.org/index.php/GNU_ZRTP";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
