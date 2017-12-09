{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "liblscp-${version}";
  version = "0.5.8";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${name}.tar.gz";
    sha256 = "00cfafkw1n80sdjwm9zdsg5vx287wqpgpbajd3zmiz415wzr84dn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool ];

  # preConfigure = "make -f Makefile.svn";

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "LinuxSampler Control Protocol (LSCP) wrapper library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
