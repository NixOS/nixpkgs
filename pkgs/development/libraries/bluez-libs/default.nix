{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bluez-libs-2.25";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bluez-libs-2.25.tar.gz;
    md5 = "ebc8408c9a74c785786a2ef7185fe628";
  };
}
