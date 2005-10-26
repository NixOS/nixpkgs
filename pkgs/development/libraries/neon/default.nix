{stdenv, fetchurl, libxml2}:

stdenv.mkDerivation {
  name = "neon-0.25.4";
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.25.4.tar.gz;
    md5 = "4448c3a91e80429ea733aec8ce300009";
  };
  buildInputs = [libxml2];
}
