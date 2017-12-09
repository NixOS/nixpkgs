{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "liblscp-${version}";
  version = "0.5.8";

  src = fetchurl {
    url = "http://download.linuxsampler.org/packages/${name}.tar.gz";
    sha256 = "00cfafkw1n80sdjwm9zdsg5vx287wqpgpbajd3zmiz415wzr84dn";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  preConfigure = "make -f Makefile.git";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "LinuxSampler Control Protocol (LSCP) wrapper library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
