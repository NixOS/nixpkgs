{ callPackage, apacheHttpd }:
callPackage ./makePhpDerivation.nix {
  phpVersion = "5.4.40";
  sha = "06m5b3hw5kgwvnarhiylymadj504xalpczagr662vjrwmklgz628";
  apacheHttpd = apacheHttpd;
}
