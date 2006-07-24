{stdenv, fetchurl, libxml2}:

stdenv.mkDerivation {
  name = "neon-0.25.5";
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.25.5.tar.gz;
    md5 = "b5fdb71dd407f0a3de0f267d27c9ab17";
  };
  buildInputs = [libxml2];
}
