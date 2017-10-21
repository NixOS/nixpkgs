{stdenv, fetchurl, gmp}:
stdenv.mkDerivation rec {
  name = "cddlib-${version}";
  fileVersion = "094h";
  version = "0.94h";
  src = fetchurl {
    urls = [
      "http://archive.ubuntu.com/ubuntu/pool/universe/c/cddlib/cddlib_${fileVersion}.orig.tar.gz"
      "ftp://ftp.math.ethz.ch/users/fukudak/cdd/cddlib-${fileVersion}.tar.gz"
    ];
    name = "";
    sha256 = "1dasasscwfg793q8fwzgwf64xwj7w62yfvszpr8x8g38jka08vgy";
  };
  buildInputs = [gmp];
  meta = {
    inherit version;
    description = ''An implementation of the Double Description Method for generating all vertices of a convex polyhedron'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://www.inf.ethz.ch/personal/fukudak/cdd_home/index.html;
  };
}
