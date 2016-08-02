{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "rlog-1.4";

  src = fetchurl {
    url = "http://rlog.googlecode.com/files/rlog-1.4.tar.gz";
    sha256 = "0y9zg0pd7vmnskwac1qdyzl282z7kb01nmn57lsg2mjdxgnywf59";
  };

  meta = {
    homepage = http://www.arg0.net/rlog;
    description = "A C++ logging library used in encfs";
    platforms = stdenv.lib.platforms.linux;
  };
}
