{ stdenv, fetchurl, autoconf, automake, libtool, mesa, libva, libdrm, libX11, pkgconfig }:

stdenv.mkDerivation rec {
  name = "intel-driver-1.0.19";
  
  src = fetchurl {
    url = "http://cgit.freedesktop.org/intel-driver/snapshot/${name}.tar.bz2";
    sha256 = "1ns6y1hdqvqd92mc0d6axyh17rgyzp73xnbf97mnnzi9fc47x6p1";
  };

  buildInputs = [ autoconf automake libtool mesa libva pkgconfig libdrm libX11 ];

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
