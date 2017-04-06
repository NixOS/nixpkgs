{ stdenv, fetchurl, expat, zlib, boost }:

stdenv.mkDerivation rec {
  name = "exempi-2.4.2";

  src = fetchurl {
    url = "http://libopenraw.freedesktop.org/download/${name}.tar.bz2";
    sha256 = "1v665fc7x0yi7x6lzskvd8bd2anf7951svn2vd5384dblmgv43av";
  };

  configureFlags = [
    "--with-boost=${boost.dev}"
  ];

  buildInputs = [ expat zlib boost ];

  meta = with stdenv.lib; {
    homepage = http://libopenraw.freedesktop.org/wiki/Exempi/;
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
