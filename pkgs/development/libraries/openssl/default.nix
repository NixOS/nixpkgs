{stdenv, fetchurl, perl}: stdenv.mkDerivation {
  name = "openssl-0.9.7i";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/openssl-0.9.7i.tar.gz;
    sha1 = "4c23925744d43272fa19615454da44e01465eb06";
  };
  buildInputs = [perl];
#  patches = [./darwin-makefile.patch];
}
