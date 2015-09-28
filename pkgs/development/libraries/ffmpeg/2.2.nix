{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.15";
  branch = "2.2";
  sha256 = "1s2mf1lvvwj6vkbp0wdr21xki864xsfi1rsjaa67q5m9dx4rrnr4";
})
