{
  stdenv,
  fetchurl,
  undmg,
  cpio,
  xar,
  lib,
}:

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
    else if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "mirror://sourceforge/project/freepascal/Mac%20OS%20X/${version}/fpc-${version}.intelarm64-macosx.dmg";
        sha256 = "05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d";
      }
    else
      throw "Not supported on ${stdenv.hostPlatform.system}.";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    undmg
    xar
    cpio
  ];

  builder =
    if stdenv.hostPlatform.isLinux then
      ./binary-builder.sh
    else if stdenv.hostPlatform.isDarwin then
      ./binary-builder-darwin.sh
    else
      throw "Not supported on ${stdenv.hostPlatform}.";

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
}
