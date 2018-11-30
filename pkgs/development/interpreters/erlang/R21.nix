{ mkDerivation }:

mkDerivation rec {
  version = "21.1.3";
  sha256 = "0374qpafrpnfspsvjaa3sgs0h8ryi3ah8fvmr7dm7zsmgb4ihdsg";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
