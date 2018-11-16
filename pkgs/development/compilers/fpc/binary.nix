{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "fpc-2.6.0-binary";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/2.6.0/fpc-2.6.0.i386-linux.tar";
        sha256 = "08yklvrfxvk59bxsd4rh1i6s3cjn0q06dzjs94h9fbq3n1qd5zdf";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/2.6.0/fpc-2.6.0.x86_64-linux.tar";
        sha256 = "0k9vi75k39y735fng4jc2vppdywp82j4qhzn7x4r6qjkad64d8lx";
      }
    else throw "Not supported on ${stdenv.hostPlatform.system}.";

  builder = ./binary-builder.sh;

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
} 
