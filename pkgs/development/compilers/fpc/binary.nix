{ stdenv, fetchOneOf }:

stdenv.mkDerivation {
  name = "fpc-2.6.0-binary";

  src = fetchOneOf stdenv.system {
    "i686-linux" = {
      url = "mirror://sourceforge/project/freepascal/Linux/2.6.0/fpc-2.6.0.i386-linux.tar";
      sha256 = "08yklvrfxvk59bxsd4rh1i6s3cjn0q06dzjs94h9fbq3n1qd5zdf";
    };
    "x86_64-linux" = {
      url = "mirror://sourceforge/project/freepascal/Linux/2.6.0/fpc-2.6.0.x86_64-linux.tar";
      sha256 = "0k9vi75k39y735fng4jc2vppdywp82j4qhzn7x4r6qjkad64d8lx";
    };
  };

  builder = ./binary-builder.sh;

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
} 
