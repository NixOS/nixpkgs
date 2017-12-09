{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "20.1.7";
  sha256 = "0sbxl10d76bm7awxb9s07l9815jiwfg78bps07xj2ircxdr08pls";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
