{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "xerces-c-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${name}.tar.gz";
    sha256 = "18045nyjkr2hygkjc43pi2fmz6qcbn9p00kf42my3aa4i0mn1m3d";
  };

  meta = {
    homepage = http://xerces.apache.org/xerces-c/;
    description = "Validating XML parser written in a portable subset of C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
