{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.5.28";
  sha = "1wy2v5rmbiia3v6fc8nwg1y3sdkdmicksxnkadz1f3035rbjqz8r";
  apacheHttpd = apacheHttpd;
}
