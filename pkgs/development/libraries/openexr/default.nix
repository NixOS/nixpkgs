{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "openexr-1.2.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/OpenEXR-1.2.2.tar.gz;
    md5 = "a2e56af78dc47c7294ff188c8f78394b";
  };
  buildInputs = [zlib];
}
