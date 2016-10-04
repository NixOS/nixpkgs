{ stdenv, fetchgit, cairo, libjpeg, libXft, pkgconfig, python2 }:

stdenv.mkDerivation rec {
  name = "ntk-${version}";
  version = "2014-10-18";
  src = fetchgit {
    url = "git://git.tuxfamily.org/gitroot/non/fltk.git";
    rev = "5719b0044d9f267de5391fab006370cc7f4e70bd";
    sha256 = "1wpqy5kk6sk31qyx1c6gdslcqcbczgji6lk8w1l8kri0s908ywyj";
  };

  buildInputs = [
    cairo libjpeg libXft pkgconfig python2
  ];

  buildPhase = ''
    python waf configure --prefix=$out
    python waf
  '';

  installPhase = ''
    python waf install
  '';

  meta = {
    description = "Fork of FLTK 1.3.0 with additional functionality";
    version = "${version}";
    homepage = http://non.tuxfamily.org/;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
