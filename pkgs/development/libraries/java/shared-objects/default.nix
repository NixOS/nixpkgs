{stdenv, fetchurl, jdk}:

stdenv.mkDerivation {
  name = "shared-objects-1.4";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/shared-objects/shared-objects-1.4.tar.gz;
    md5 = "c1f2c58bd1a07be32da8a6b89354a11f";
  };
  buildInputs = [stdenv jdk];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
