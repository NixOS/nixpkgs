{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fpc-binary";
  version = "3.2.2";

  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/${version}/fpc-${version}.i386-linux.tar";
        sha256 = "f62980ac0b2861221f79fdbff67836aa6912a4256d4192cfa4dfa0ac5b419958";
      }
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/${version}/fpc-${version}.x86_64-linux.tar";
        sha256 = "5adac308a5534b6a76446d8311fc340747cbb7edeaacfe6b651493ff3fe31e83";
      }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Linux/${version}/fpc-${version}.aarch64-linux.tar";
        sha256 = "b39470f9b6b5b82f50fc8680a5da37d2834f2129c65c24c5628a80894d565451";
      }
    else throw "Not supported on ${stdenv.hostPlatform.system}.";

  builder = ./binary-builder.sh;

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
}
