{ stdenv, fetchurl, pkgconfig, libmowgli }:

stdenv.mkDerivation rec {
  name = "libmcs-0.7.2";
  
  src = fetchurl {
    url = "http://distfiles.atheme.org/${name}.tbz2";
    sha256 = "1knmgxrg2kxdlin8qyf6351943ldg8myllwf860af58x1wncxc74";
  };

  buildInputs = [ pkgconfig libmowgli ];
  
  meta = {
    description = "A library and set of userland tools which abstract the storage of configuration settings away from userland applications";
    homepage = http://www.atheme.org/projects/mcs.shtml;
    platforms = stdenv.lib.platforms.unix;
  };
}
