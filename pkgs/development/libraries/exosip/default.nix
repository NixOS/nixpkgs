{ stdenv, fetchurl, libosip, openssl, pkgconfig, fetchpatch }:

stdenv.mkDerivation rec {
 name = "libexosip2-${version}";
 version = "4.1.0";

 src = fetchurl {
    url = "mirror://savannah/exosip/libeXosip2-${version}.tar.gz";
    sha256 = "17cna8kpc8nk1si419vgr6r42k2lda0rdk50vlxrw8rzg0xp2xrw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libosip openssl ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/libe/libexosip2/4.1.0-2.1/debian/patches/openssl110.patch";
      sha256 = "01q2dax7pwh197mn18r22y38mrsky85mvs9vbkn9fpcilrdayal6";
    })
  ];

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    description = "Library that hides the complexity of using the SIP protocol";
    platforms = platforms.linux;
  };
}
