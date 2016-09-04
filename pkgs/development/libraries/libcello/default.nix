{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libcello-0.9.2";

  src = fetchurl {
    url = "http://libcello.org/static/${name}.tar.gz";
    sha256 = "cd82639cb9b133119fd89a77a5a505a55ea5fcc8decfc53bee0725358ec8bad0";
  };

  meta = {
    homepage = http://libcello.org/;
    description = "Higher level programming in C";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
