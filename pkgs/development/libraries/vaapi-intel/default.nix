{ stdenv, fetchurl, autoconf, automake, libtool, mesa, libva, libdrm, libX11, pkgconfig
, intelgen4asm }:

stdenv.mkDerivation rec {
  name = "libva-intel-driver-1.0.20";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/${name}.tar.bz2";
    sha256 = "1jfl8909j3a3in6m8b5bx3dn7pzr8a1sw3sk4vzm7h3j2dkgpzhj";
  };

  buildInputs = [ pkgconfig libdrm libva libX11 ];

  preConfigure = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = {
    homepage = http://cgit.freedesktop.org/vaapi/intel-driver/;
    license = "MIT";
    description = "Intel driver for the VAAPI library";
  };
}
