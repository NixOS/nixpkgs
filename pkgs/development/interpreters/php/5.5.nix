{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.5.25";
  sha = "0qrc4qll07hfs5a3l4ajrj7969w10d0n146zq1smdl6x4pkkgpv8";
  apacheHttpd = apacheHttpd;
}
