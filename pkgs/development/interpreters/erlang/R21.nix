{ mkDerivation }:

mkDerivation {
  version = "21.3.8.21";
  sha256 = "sha256-zQCs2hOA66jxAaxl/B42EKCejAktIav2rpVQCNyKCh4=";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
  '';
}
