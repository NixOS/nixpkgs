{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "liblscp";
  version = "0.6.0";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${pname}-${version}.tar.gz";
    sha256 = "1rl7ssdzj0z3658yvdijmb27n2lcwmplx4qxg5mwrm07pvs7i75k";
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
