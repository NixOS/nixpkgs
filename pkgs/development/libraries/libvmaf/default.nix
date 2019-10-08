{ stdenv, fetchFromGitHub, autoconf, automake, intltool, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libvmaf";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "netflix";
    repo = "vmaf";
    rev = "v${version}";
    sha256="13ajbcidngjvgl0rr7l0mb43h651p5pqj3d1linrfk9c222b9fs3";
  };

  nativeBuildInputs = [ autoconf automake intltool libtool pkgconfig ];
  doCheck = true;

  installPhase = ''
    make INSTALL_PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Netflix/vmaf";
    description = "Perceptual video quality assessment based on multi-method fusion (VMAF).";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = [ maintainers.cfsmp3 ];
  };

}
