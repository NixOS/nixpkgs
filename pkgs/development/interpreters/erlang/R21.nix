{ mkDerivation }:

mkDerivation rec {
  version = "21.3.7.1";
  sha256 = "03vbp22vwra3zz76q3sjv23lmic60gi96a7dncry8whbfp4i4j8a";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
