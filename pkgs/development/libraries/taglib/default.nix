{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "taglib-1.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/taglib-1.4.tar.gz;
    md5 = "dcd50ddb2544faeae77f194804559404";
  };
  buildInputs = [zlib];
}
