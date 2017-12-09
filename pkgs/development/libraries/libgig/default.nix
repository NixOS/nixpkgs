{ stdenv, fetchurl, autoconf, automake, libsndfile, libtool, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  name = "libgig-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "http://download.linuxsampler.org/packages/${name}.tar.bz2";
    sha256 = "02xx6bqxzgkvrawwnzrnxx1ypk244q4kpwfd58266f9ji8kq18h6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libsndfile libtool libuuid ];

  preConfigure = "make -f Makefile.cvs";

  meta = with stdenv.lib; {
    homepage = http://www.linuxsampler.org;
    description = "Gigasampler file access library";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
