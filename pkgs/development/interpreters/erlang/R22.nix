{ mkDerivation }:

mkDerivation {
  version = "22.0.4";
  sha256 = "1aqkhd6nwdn4xp5yz02zbymd4x8ij8fjw9ji8kh860n1a513k9ai";

  prePatch = ''
    substituteInPlace make/configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
    substituteInPlace erts/configure.in --replace '-Wl,-no_weak_imports' ""
  '';
}
