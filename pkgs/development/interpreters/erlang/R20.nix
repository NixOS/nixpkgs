{ mkDerivation }:

mkDerivation {
  version = "20.3.8.26";
  sha256 = "062405s59hkdkmw2dryq0qc1k03jsncj7yqisgj35x9sqpzm4w7a";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
  '';
}
