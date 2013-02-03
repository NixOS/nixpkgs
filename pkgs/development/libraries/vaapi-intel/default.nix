{ stdenv, fetchurl, autoconf, automake, libtool, mesa, libva, libdrm, libX11, pkgconfig
, intelgen4asm }:

stdenv.mkDerivation rec {
  name = "libva-intel-driver-1.0.19";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/${name}.tar.bz2";
    sha256 = "14m7krah3ajkwj190q431lqqa84hdljcdmrcrqkbgaffyjlqvdid";
  };

  buildInputs = [ autoconf automake libtool mesa libva pkgconfig libdrm libX11 intelgen4asm ];

  preConfigure = ''
    sh autogen.sh
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = {
    homepage = http://cgit.freedesktop.org/vaapi/intel-driver/;
    license = "MIT";
    description = "Intel driver for the VAAPI library";
  };
}
