{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "libvorbis-1.1.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libvorbis-1.1.2.tar.gz;
    md5 = "37847626b8e1b53ae79a34714c7b3211";
  };
  buildInputs = [libogg];
}
