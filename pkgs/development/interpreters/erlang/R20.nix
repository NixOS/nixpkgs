{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "20.0";
  sha256 = "12dbay254ivnakwknjn5h55wndb0a0wqx55p156h8hwjhykj2kn0";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
