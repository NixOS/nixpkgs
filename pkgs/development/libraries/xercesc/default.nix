{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "xerces-c-${version}";
  version = "3.1.4";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${name}.tar.gz";
    sha256 = "1xpccqzykpd3806kd788lgkl01pk7v5lklva6q4kp9zq9jnfv3n9";
  };

  meta = {
    homepage = http://xerces.apache.org/xerces-c/;
    description = "Validating XML parser written in a portable subset of C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
