{ stdenv, fetchurl, autoconf, automake, libtool, mesa, libva, libdrm, libX11, pkgconfig
, intelgen4asm }:

stdenv.mkDerivation rec {
  name = "libva-intel-driver-1.2.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/${name}.tar.bz2";
    sha256 = "0i3h9g8flnxf8gmag65xkvz7rib51dvx841ym3am5v3p51w79i0r";
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
