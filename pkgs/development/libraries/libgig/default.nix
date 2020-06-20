{ stdenv, fetchurl, autoconf, automake, libsndfile, libtool, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  pname = "libgig";
  version = "4.2.0";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${pname}-${version}.tar.bz2";
    sha256 = "1zs5yy124bymfyapsnljr6rv2lnn5inwchm0xnwiw44b2d39l8hn";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  buildInputs = [ libsndfile libuuid ];

  preConfigure = "make -f Makefile.svn";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://www.linuxsampler.org";
    description = "Gigasampler file access library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
