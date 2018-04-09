{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "20.3.1";
  sha256 = "13qh3an98qm477zr1dvcklbhar001cikp177295llcqpchamgzx3";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
