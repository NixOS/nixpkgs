{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "0.16.19";
  sha256 = "1nlrivhnshn4wd9m5dsbjmq84731z9f9glj5q3vxz0c01s1lv7vw";
})
