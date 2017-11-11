{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "20.1";
  sha256 = "13f53lzgq2himg9kax41f66rzv5pjfrb1ln8b54yv9spkqx2hqqi";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
