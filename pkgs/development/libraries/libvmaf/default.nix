{ stdenv, fetchurl, autoconf, automake, intltool, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libvmaf";
  version = "1.3.15";

  src = fetchurl {
    url="https://github.com/Netflix/vmaf/archive/v1.3.15.tar.gz";
    sha256="13ajbcidngjvgl0rr7l0mb43h651p5pqj3d1linrfk9c222b9fs3";
  };

  buildInputs = [ autoconf automake intltool libtool pkgconfig ];
  doCheck = true;

  installPhase = ''
    make INSTALL_PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Netflix/vmaf";
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF).";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.asl20;
    maintainers = [ maintainers.cfsmp3 ];
  };

}
