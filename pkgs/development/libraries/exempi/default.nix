{ stdenv, fetchurl, expat, zlib, boost }:

stdenv.mkDerivation rec {
  name = "exempi-2.2.1";

  src = fetchurl {
    url = "http://libopenraw.freedesktop.org/download/${name}.tar.bz2";
    sha256 = "00d6gycl0wcyd3c71y0jp033a64z203rq0p0y07aig0s0j0477kc";
  };

  configureFlags = [ "--with-boost=${boost}" ];

  buildInputs = [ expat zlib boost ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
