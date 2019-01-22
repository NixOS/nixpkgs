{ mkDerivation }:

mkDerivation rec {
  version = "21.2.3";
  sha256 = "1v47c7bddbp31y6f8yzdjyvgcx9sskxql33k7cs0p5fmr05hhxws";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
