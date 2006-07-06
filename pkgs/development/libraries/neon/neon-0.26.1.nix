{stdenv, fetchurl, libxml2}:

stdenv.mkDerivation {
  name = "neon-0.26.1";
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.26.1.tar.gz;
    md5 = "3bb7a82bddfc1c56d2f9dba849aecd1f";
  };
  buildInputs = [libxml2];
}
