{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook5-5.0-pre-beta7";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/docbook-5.0b7.tar.gz;
    md5 = "f1e18aaf56b0f0b2b2ab9eaff4bb6a1e";
  };
}
