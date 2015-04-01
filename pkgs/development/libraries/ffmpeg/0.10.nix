{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.15";
  branch = "0.10";
  sha256 = "0p9x559fpj4zxll7rn3kwdig6y66c3ahv3pddmz23lljq5rvyvcb";
})
