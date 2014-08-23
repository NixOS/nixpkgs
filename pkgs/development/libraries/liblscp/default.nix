{ stdenv, fetchsvn, autoconf, automake, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "liblscp-svn-${version}";
  version = "2319";

  src = fetchsvn {
    url = "https://svn.linuxsampler.org/svn/liblscp/trunk";
    rev = "${version}";
    sha256 = "0jgdy9gi9n8x2pqrbll9158vhx8293lnxv8vzl0szcincslgk7hi";
  };

  buildInputs = [ autoconf automake libtool pkgconfig ];

  preConfigure = "make -f Makefile.svn";

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "LinuxSampler Control Protocol (LSCP) wrapper library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
