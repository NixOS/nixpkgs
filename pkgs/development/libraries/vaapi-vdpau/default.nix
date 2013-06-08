{ stdenv, fetchurl, libvdpau, mesa, libva, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libva-vdpau-driver-0.7.4";
  
  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/${name}.tar.bz2";
    sha256 = "1fcvgshzyc50yb8qqm6v6wn23ghimay23ci0p8sm8gxcy211jp0m";
  };

  buildInputs = [ libvdpau mesa libva pkgconfig ];

  preConfigure = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = {
    homepage = http://cgit.freedesktop.org/vaapi/vdpau-driver/;
    license = "GPLv2+";
    description = "VDPAU driver for the VAAPI library";
  };
}
