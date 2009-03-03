args: with args;

stdenv.mkDerivation {
  name = "fpc-2.2.2-binary";

  src = fetchurl {
    url = ftp://ftp.chg.ru/pub/lang/pascal/fpc/dist/i386-linux-2.2.2/fpc-2.2.2.i386-linux.tar;
    sha256 = "8c18f63b36a76eee673f96ca254c49c5a42bcf3e36279abe8774f961792449a5";
  };

  builder = ./binary-builder.sh;

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
} 
