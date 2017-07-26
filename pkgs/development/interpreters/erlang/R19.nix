{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "19.3";
  sha256 = "0pp2hl8jf4iafpnsmf0q7jbm313daqzif6ajqcmjyl87m5pssr86";

  prePatch = ''
    substituteInPlace configure.in --replace '`sw_vers -productVersion`' '10.10'
  '';
}
