{stdenv, fetchurl}:

# I want some provides mechanism for jar files. These
# jars can then be added to the CLASSPATH by a dependent package.

stdenv.mkDerivation {
  name = "jakarta-regexp-1.4";
  builder = ./java-bin-builder.sh;

  src = fetchurl {
    url = http://nixos.org/tarballs/jakarta-regexp-1.4.tar.gz;
    md5 = "d903d84c949df848009f3bf205b32c97";
  };

  jars = ["jakarta-regexp-1.4.jar"];

  buildInputs = [stdenv];
}
