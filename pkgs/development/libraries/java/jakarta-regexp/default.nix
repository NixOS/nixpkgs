{stdenv, fetchurl}:

# I want some provides mechanism for jar files. These
# jars can then be added to the CLASSPATH by a dependent package.

stdenv.mkDerivation {
  name = "jakarta-regexp-1.3";
  builder = ./java-bin-builder.sh;

  src = fetchurl {
    url = http://apache.cs.uu.nl/dist/jakarta/regexp/binaries/jakarta-regexp-1.3.tar.gz;
    md5 = "4322f82bea908ca4a7db270f7fa4850d";
  };

  jars = ["jakarta-regexp-1.3.jar"];

  buildInputs = [stdenv];
}
