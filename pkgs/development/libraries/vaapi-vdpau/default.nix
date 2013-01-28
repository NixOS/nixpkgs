{ stdenv, fetchurl, autoconf, automake, libtool, libvdpau, mesa, libva, pkgconfig }:

stdenv.mkDerivation rec {
  name = "vdpau-driver-0.7.4";
  
  src = fetchurl {
    url = "http://cgit.freedesktop.org/vdpau-driver/snapshot/${name}.tar.bz2";
    sha256 = "1kvhpqwzw01bfamvxhnl4yhmb7pwkkfaii3w7bidd4vj1gsrx5l4";
  };

  buildInputs = [ autoconf automake libtool libvdpau mesa libva pkgconfig ];

  preConfigure = ''
    sh autogen.sh
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = {
    homepage = http://cgit.freedesktop.org/vaapi/vdpau-driver/;
    license = "GPLv2+";
    description = "VDPAU driver for the VAAPI library";
  };
}
