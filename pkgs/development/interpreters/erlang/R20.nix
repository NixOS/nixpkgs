{ mkDerivation }:

mkDerivation rec {
  version = "20.3.8";
  sha256 = "1griiszz1x34idmwi6234br7bqd1d7mimim63amjgi9ds79jh6jj";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
