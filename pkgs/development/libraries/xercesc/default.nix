{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "xerces-c-${version}";
  version = "3.1.3";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${name}.tar.gz";
    sha256 = "0jav1cbwcyq4miy790dd62yrypf7n0j98vdin9ny30f9nwyzgm7k";
  };

  meta = {
    homepage = http://xerces.apache.org/xerces-c/;
    description = "Validating XML parser written in a portable subset of C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
