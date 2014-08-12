{ stdenv, fetchurl, cmake, openssl, pkgconfig, ccrtp }:

stdenv.mkDerivation rec {
  name = "libzrtpcpp-2.3.4";

  src = fetchurl {
    url = "mirror://gnu/ccrtp/${name}.tar.gz";
    sha256 = "020hfyrh8qdwkqdg1r1n65wdzj5i01ba9dzjghbm9lbz93gd9r83";
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
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
