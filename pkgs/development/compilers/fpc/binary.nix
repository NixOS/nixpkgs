{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "fpc-3.0.0-binary";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/3.0.0/fpc-3.0.0.i386-linux.tar";
        sha256 = "0h3f1dgs1zsx7vvk9kg67anjvgw5sslfbmjblif7ishbcp3k3g5k";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/3.0.0/fpc-3.0.0.x86_64-linux.tar";
        sha256 = "1m2xx3nda45cb3zidbjgdr8kddd19zk0khvp7xxdlclszkqscln9";
      }
    else throw "Not supported on ${stdenv.hostPlatform.system}.";

  builder = ./binary-builder.sh;

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
} 
