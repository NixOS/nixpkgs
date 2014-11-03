{ stdenv, fetchurl, zlib, curl, expat, fuse, openssl }:

stdenv.mkDerivation rec {
  version = "3.7.4";
  name = "afflib-${version}";

  src = fetchurl {
    url = "http://digitalcorpora.org/downloads/afflib/${name}.tar.gz";
    sha256 = "18j1gjb31qjcmz6lry4m2d933w2a80iagg9g5vrpw5ig80lv10f8";
  };

  buildInputs = [ zlib curl expat fuse openssl ];

  meta = {
    homepage = http://afflib.sourceforge.net/;
    description = "Advanced forensic format library";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsdOriginal;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    inherit version;
    downloadPage = "http://digitalcorpora.org/downloads/afflib/";
    updateWalker = true;
  };
}
