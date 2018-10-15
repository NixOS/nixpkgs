{ mkDerivation }:

mkDerivation rec {
  version = "21.1.1";
  sha256 = "1kgny4nvw40d93jn5f4y5bcfhdlshg79n2w7lr0xj35kgwkyci39";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
