{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fpc-binary";
  version = "3.2.0";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/${version}/fpc-${version}.i386-linux.tar";
        sha256 = "0y0510b2fbxbqz28967xx8b023k6q9fv5yclfrc1yc9mg8fyn411";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/${version}/fpc-${version}-x86_64-linux.tar";
        sha256 = "0gfbwjvjqlx0562ayyl08khagslrws758al2yhbi4bz5rzk554ni";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/${version}/fpc-${version}.aarch64-linux.tar";
        sha256 = "1h481ngg3m8nlsg9mw7rr1bn2c4sj4wzqny9bxyq3xvcral12r71";
      }
    else throw "Not supported on ${stdenv.hostPlatform.system}.";

  builder = ./binary-builder.sh;

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
}
